## 1. Installing Free and Nonfree Repositories from Tsinghua mirror site

```bash
sudo dnf install --nogpgcheck https://mirrors.tuna.tsinghua.edu.cn/rpmfusion/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.tuna.tsinghua.edu.cn/rpmfusion/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm;
```

https://mirrors.tuna.tsinghua.edu.cn/help/rpmfusion/

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