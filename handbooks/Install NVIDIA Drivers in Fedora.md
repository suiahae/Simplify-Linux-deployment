## 1. Installing Free and Nonfree Repositories from Tsinghua mirror site

```bash
sudo dnf install --nogpgcheck https://mirrors.tuna.tsinghua.edu.cn/rpmfusion/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.tuna.tsinghua.edu.cn/rpmfusion/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm;
```

https://mirrors.tuna.tsinghua.edu.cn/help/rpmfusion/

Or from rpmfusion.org

```bash
sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
```

https://rpmfusion.org/Configuration

## 2. Installing the drivers

### Current GeForce/Quadro/Tesla

Supported on current stable Xorg server release.

This driver is suitable for any GPU found in 2012 and later.

```
sudo dnf update -y # and reboot if you are not on the latest kernel
sudo dnf install akmod-nvidia # rhel/centos users can use kmod-nvidia instead
sudo dnf install xorg-x11-drv-nvidia-cuda #optional for cuda/nvdec/nvenc support
```

**!!! Please remember to wait after the RPM transaction ends, until the kmod get built.** This can take up to 5 minutes on some systems.

Once the module is built, "`modinfo -F version nvidia`" should outputs the version of the driver such as 440.64 and not modinfo: ERROR: Module nvidia not found.

https://rpmfusion.org/Howto/NVIDIA#Installing_the_drivers



## 3. Special notes

### Optimus

With Fedora 25 and later, Optimus devices are supported automatically by default. Please see the dedicated [Optimus Howto](https://rpmfusion.org/Howto/Optimus).

#### NVIDIA PRIME Support

On Fedora 30 and later, with NVIDIA driver 440.31+, there is nothing else to be done beyound normal driver installation. But you can opt-in to enable Dynamic Power Management until this is set as the default in the NVIDIA driver.

```
sudo -s
dnf update
cat > /etc/modprobe.d/nvidia.conf <<EOF
# Enable DynamicPwerManagement
# http://download.nvidia.com/XFree86/Linux-x86_64/440.31/README/dynamicpowermanagement.html
options nvidia NVreg_DynamicPowerManagement=0x02
EOF
```

#### [DRM kernel mode setting](https://wiki.archlinux.org/index.php/NVIDIA#DRM_kernel_mode_setting)

[nvidia](https://www.archlinux.org/packages/?name=nvidia) 364.16 adds support for DRM (Direct Rendering Manager) [kernel mode setting](https://wiki.archlinux.org/index.php/Kernel_mode_setting). To enable this feature, add the `nvidia-drm.modeset=1` [kernel parameter](https://wiki.archlinux.org/index.php/Kernel_parameter). For basic functionality that should suffice, if you want to ensure it's loaded at the earliest possible occasion, or are noticing startup issues you can add `nvidia`, `nvidia_modeset`, `nvidia_uvm` and `nvidia_drm` to the initramfs according to [Mkinitcpio#MODULES](https://wiki.archlinux.org/index.php/Mkinitcpio#MODULES).

**[An easy solution to this.](https://www.reddit.com/r/SolusProject/comments/a3bnrd/having_nvidiadrmmodeset1_kernel_parameter_set/)**
First, don't put it in /etc/kernel/cmdline. The best thing to do when you have an nvidia driver installed is to go to /usr/lib/modprobe.d and make a file called zz-nvidia-modeset.conf. You then put the following code within it:

```bash
options nvidia_drm modeset=1
```

then run `clr-boot-manager update`

#### NVIDIA PrimaryGPU Support

Using PrimaryGPU allows to use the NVIDIA driver by default instead of the iGPU. This is also required in order to use external display when internally connected from the NVIDIA hardware. Unfortunately, setting this option automatically when an external display is connected is not supported by NVIDIA at this time. To recover this previous behaviour, you can use:

```
sudo cp -p /usr/share/X11/xorg.conf.d/nvidia.conf /etc/X11/xorg.conf.d/nvidia.conf
```

And edit the file to use: Option "PrimaryGPU" "yes", like this:

```bash
sudo gedit /etc/X11/xorg.conf.d/nvidia.conf
```

```
#This file is provided by xorg-x11-drv-nvidia
#Do not edit

Section "OutputClass"
        Identifier "nvidia"
        MatchDriver "nvidia-drm"
        Driver "nvidia"
        Option "AllowEmptyInitialConfiguration"
        Option "PrimaryGPU" "yes"
        Option "SLI" "Auto"
        Option "BaseMosaic" "on"
EndSection

Section "ServerLayout"
        Identifier "layout"
        Option "AllowNVIDIAGPUScreens"
EndSection
```

### CUDA

The driver support CUDA when installing the xorg-x11-drv-nvidia-cuda subpackage. Please have a look on the dedicated [CUDA Howto](https://rpmfusion.org/Howto/CUDA)

```
sudo dnf install xorg-x11-drv-nvidia-cuda
```

### KMS

KMS stands for "Kernel Mode Setting" which is the opposite of "Userland Mode Setting". This feature allows to set the screen resolution on the kernel side once (at boot), instead of after login from the display manager. This feature has early support in the main NVIDIA driver, but is not enabled by default yet as it may crash. To enable, use:

```
sudo grubby --update-kernel=ALL --args='nvidia-drm.modeset=1'
```

Please have a look at the Wayland section if using it (specially for gnome users).

### Vulkan

The main package support Vulkan, but you need to install the vulkan libraries if requested.

```
sudo dnf install vulkan
```

### NVENC/NVDEC

RPM Fusion support ffmpeg compiled with NVENC/NVDEC with Fedora 25 and later. You need to have a recent NVIDIA card (see the [support matrix](https://developer.nvidia.com/ffmpeg)), and install the cuda sub-package.

```
sudo dnf install xorg-x11-drv-nvidia-cuda-libs
```

Please have a look on the ffmpeg [HWAccel introduction](https://trac.ffmpeg.org/wiki/HWAccelIntro#NVENC) to the feature

### nvidia-xconfig

This tool is only meant to be used as a sample to create a xorg.conf files. But don't use this directly as the generated xorg.conf is known to broke with many default Fedora/RHEL Xorg server options. Instead, you should probably start with :

```
sudo cp /usr/share/X11/xorg.conf.d/nvidia.conf /etc/X11/xorg.conf.d/nvidia.conf
```

### x86_64 (64bit) users

If you wish to have 3D acceleration in 32bit packages such as Wine, be sure to install the appropriate 32bit version of the xorg-x11-drv-nvidia-libs package for your driver variant. For example, if you installed kmod-nvidia then you will require xorg-x11-drv-nvidia-libs.i686. With Current Fedora (not EL), this is handled automatically by RPM (Boolean dependencies).

### VDPAU/VAAPI

In order to enable video acceleration support for your player and if your NVIDIA card is recent enough (Geforce 8 and later is needed). You can install theses packages:

```
# sudo dnf install vdpauinfo libva-vdpau-driver libva-utils libvdpau-va-gl
```

With the native vdpau backend from a NVIDIA card, the output is similar to this:

```
$ vdpauinfo 
display: :0.0   screen: 0
API version: 1
Information string: NVIDIA VDPAU Driver Shared Library  375.66  Mon May  1 14:32:38 PDT 2017
...
```

Here is an example of an accurate output of vainfo, when the bridge to the VAAPI is correctly installed.

```
$ vainfo 
libva info: VA-API version 0.40.0
libva info: va_getDriverName() returns 0
libva info: Trying to open /usr/lib64/dri/nvidia_drv_video.so
libva info: Found init function __vaDriverInit_0_40
libva info: va_openDriver() returns 0
vainfo: VA-API version: 0.40 (libva )
vainfo: Driver version: Splitted-Desktop Systems VDPAU backend for VA-API - 0.7.4
vainfo: Supported profile and entrypoints
...
```

## 4. Tools

https://github.com/bosim/FedoraPrime