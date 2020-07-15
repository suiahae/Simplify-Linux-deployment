---
title: 为 ThinkPad T470 启用 Fedora 32 指纹认证
comments: true
date: 2020-06-11 15:31:42
updated:
tags:
- [Fedora]
categories:
- [Handbooks, Linux]
---

# Enabling the fingerprint reader on ThinkPad T470 in Fedora 32

The Thinkpad T470 comes equipped with a fingerprint scanner to allow easier authorization.  Unfortunately, the drivers are still under prototype development but are working in Fedora.  In order to use the fingerprint scanner, it needs to be initialized with data which can only currently be done from Windows(**This section is at the end of the article**).

## 1. Installing fprintd in Fedora

Fedora comes with fingerprint authentication however it does not recognize the fingerprint scanner that comes with the T470.  Start by downloading the base packages and re-compile the drivers after.

But the defaule packages version is too new to use.  Fedora updated fprintd to the latest version, which requires libfprint-2.so, which is not provided by this modified libfprint. We'll have to stick with an older version of fprintd.

Remove latest version.

```bash
sudo dnf -y remove fprintd fprintd-pam
```

Download and install old version from archive depositary([fprint](https://koji.fedoraproject.org/koji/buildinfo?buildID=1355724), [libfprint](https://koji.fedoraproject.org/koji/buildinfo?buildID=1440636)).

```bash
fprint_t470='https://kojipkgs.fedoraproject.org//packages/fprintd/0.9.0/1.fc32/x86_64/fprintd-0.9.0-1.fc32.x86_64.rpm';
fprint_pam_t470='https://kojipkgs.fedoraproject.org//packages/fprintd/0.9.0/1.fc32/x86_64/fprintd-pam-0.9.0-1.fc32.x86_64.rpm';
libfprint_t470='https://kojipkgs.fedoraproject.org//packages/libfprint/1.0/2.fc32/x86_64/libfprint-1.0-2.fc32.x86_64.rpm';

wget $fprint_t470 $fprint_pam_t470 $libfprint_t470;

sudo dnf install ./fprintd-0.9.0-1.fc32.x86_64.rpm ./fprintd-pam-0.9.0-1.fc32.x86_64.rpm ./libfprint-1.0-2.fc32.x86_64.rpm;
```

Add `exclude=fprint* libfprint` to the last line of `/etc/dnf/dnf.conf` to disable the update.

```bash
sudo echo "exclude=fprintd* libfprint" >> /etc/dnf/dnf.conf
```

Next, clone the modified libfprint library from https://github.com/hrenod/libfprint

```bash
git clone https://github.com/hrenod/libfprint.git
cd ~/libfprint
```

Most documentation for this library and its parent repositories are applicable to Debian based systems. Dependency naming conventions on RHEL systems differ slightly but the packages should be roughly the same.  Install the dependencies using yum package manager (zsh users may need to quote "libusb*-devel" if the extended globbing option is enabled).

```bash
sudo dnf -y install gcc-c++ gtk3-devel "libusb*-devel" libXv-devel libtool libgcrypt-devel glib2-devel nss-devel libusb-devel openssl-devel libpng-devel gnutls-devel
```

Once dependencies are installed, compile the updated headers.

```
./autogen.sh
make
sudo make install
```

Test that the new drivers are working.

```
cd examples
sudo ./enroll 
```

Agree to the options when prompted, nothing will be overwritten. Then, verify your print.

```
sudo ./verify
```

If the fingerprint is a MATCH, move on to the setting up fingerprint authorization.

## 2. Configuring fprintd

In order for the fingerprint scanner to be available to the user, you need to update the device permissions.  Since these permissions are set by the kernel at boot, register a new service that will update them before logging.

```
sudo vim /etc/systemd/system/set-permissions.service
```

Copy the following contents:

`/etc/systemd/system/set-permissions.service`

```ini
[Unit]
Description=Set fingerprint reader as readable to everybody
Before=set-permissions.service

[Service]
Type=oneshot
User=root
ExecStart=/bin/bash -c "/bin/chmod a+r /sys/class/dmi/id/product_serial"

[Install]
WantedBy=multi-user.target
```

Register the service at boot, start the service and verify that it worked.

```
sudo systemctl enable set-permissions.service
sudo systemctl start set-permissions.service
sudo systemctl status set-permissions.service
```

Link the path to the newly compiled driver to ldconfig and reload the cache.

```
sudo su
echo "/usr/local/lib" > /etc/ld.so.conf.d/libfprint.conf
ldconfig
```

While you are still root, verify that the drivers have been loaded and accessible to the system.

```
fprintd-enroll --finger=right-index-finger 
```

If successful, exit to the user shell and re-enroll as your user.

```
exit
fprintd-enroll --finger=right-index-finger 
```

## [3. Login configuration](https://wiki.archlinux.org/index.php/Fprint#Configuration)

Each component of authorization has its own set of rules defined in */etc/pam.d/* and can be individually configured to use the fingerprint scanner.

Add the following line to the top of any file (under the shebang) where you would like fingerprint authorization.

```
auth       sufficient   pam_fprintd.so
```

Some example files include:

| File                    | Purpose                                        |
| ----------------------- | ---------------------------------------------- |
| /etc/pam.d/gdm-password | Authorize on login screen                      |
| /etc/pam.d/polkit-1     | GNOME polkit authentication                    |
| /etc/pam.d/sudo         | Authorize when running single commands as root |
| /etc/pam.d/su           | Authorize when trying to escalate to root user |

Adding `pam_fprintd.so` as *sufficient* to any configuration file in `/etc/pam.d/` when a fingerprint signature is present will only prompt for fingerprint authentication, preventing the use of a password. In order to use either a password or a fingerprint, add the following line to the top of any files required:

```
/etc/pam.d/sudo
auth		sufficient  	pam_unix.so try_first_pass likeauth nullok
auth		sufficient  	pam_fprintd.so
...
```

This will prompt for a password, if the field is left blank and enter is pressed it will proceed to fingerprint authentication.(don't work on `/etc/pam.d/polkit-1`)

## 0. Installing Windows in VirtualBox

First make sure your system is up to date.

```bash
sudo dnf update
```

Restart the machine in order to proceed.  In order for VirtualBox to work, some settings need to be tweaked in the BIOS.  Restarting also ensures that you're running the latest kernel after updating.

Press Enter at the boot screen followed by F1 to enter the BIOS settings.  These changes can be reverted after successfully writing your fingerprint data.  In the BIOS settings screen:

- Disable secure boot
- Enable hardware virtualization

Before proceeding with installation, download a copy of Windows 10 (64-bit) from:

https://www.microsoft.com/en-us/software-download/windows10

Then, as root, install VirtualBox.

```bash
sudo su
cd /etc/yum.repos.d
wget http://download.virtualbox.org/virtualbox/rpm/fedora/virtualbox.repo
dnf install VirtualBox-6.0
```

Rebuild the kernel modules and return to your user's shell

```bash
/usr/lib/virtualbox/vboxdrv.sh setup
exit
```

Add your user to the VirtualBox group and verify

```bash
sudo usermod -a -G vboxusers $USER
```

Now create a directory where you'll store your VirtualBox images and iso files.

```bash
mkdir -p ~/VirtualBox/iso
```

From the System tab in the Applications menu, launch Oracle VM VirtualBox and click "New" to create a new virtual machine.  Name the machine "Windows 10", select the VirtualBox directory that you just created (not iso), and select *Windows 10 (64-bit)* as the version.

Allocate 3072 MB of RAM and proceed to virtual hard disk setup.  The disk should be a VDI type disk with dynamically allocated space.  Give it an upper bounds of 32GB and create.

In order for USB 2.0 and 3.0 devices to work, download and install the *VirtualBox 6.0.14 Oracle VM VirtualBox Extension Pack* from here:

https://download.virtualbox.org/virtualbox/6.0.14/Oracle_VM_VirtualBox_Extension_Pack-6.0.14.vbox-extpack:

Enable USB 2.0 from the virtual machine's USB settings. 

\* You may need to reboot your host machine (laptop) in order for these changes to take effect).

Before you boot, you need to re-configure your disks.  From the machine's Settings, in the storage pane:

- Update the *Windows 10.vdi* as a solid-state drive
- Delete the default optical drive
- Create a new optical drive and select the downloaded Window .iso.

Run through the Windows setup process and download the Synaptics MOC driver from Lenovo's support site here: 

https://support.lenovo.com/us/en/downloads/ds120295

Attach the fingerprint scanner to Windows from the USB settings in the VitrtualBox footer (windowed mode). You should now be able to register your fingerprint from > Settings > Accounts > Sign-In Options > Windows Hello Fingerprint



---

**[modify from] https://brod.co/articles/enabling-the-fingerprint-reader-on-a-thinkpad-t470-in-fedora-31**
