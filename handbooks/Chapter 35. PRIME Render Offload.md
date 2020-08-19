| Chapter 35. PRIME Render Offload                             |                                                     |                                                              |
| ------------------------------------------------------------ | --------------------------------------------------- | ------------------------------------------------------------ |
| [Prev](https://download.nvidia.com/XFree86/Linux-x86_64/435.17/README/randr14.html) | Part I. Installation and Configuration Instructions | [Next](https://download.nvidia.com/XFree86/Linux-x86_64/435.17/README/kms.html) |

------

## Chapter 35. PRIME Render Offload

PRIME render offload is the ability to have an X screen rendered by one GPU, but choose certain applications within that X screen to be rendered on a different GPU. This is particularly useful in combination with dynamic power management to leave an NVIDIA GPU powered off, except when it is needed to render select performance-sensitive applications.

The GPU rendering the majority of the X screen is known as the "sink", and the GPU to which certain application rendering is "offloaded" is known as the "source". The render offload source produces content that is presented on the render offload sink. The NVIDIA driver can function as a PRIME render offload source, to offload rendering of GLX+OpenGL or Vulkan, presenting to an X screen driven by the xf86-video-modesetting X driver.



### X Server Requirements

NVIDIA's PRIME render offload support requires the following git commits in the X.Org X server:

- 7f962c70 - xsync: Add resource inside of SyncCreate, export SyncCreate
- 37a36a6b - GLX: Add a per-client vendor mapping
- 8b67ec7c - GLX: Use the sending client for looking up XID's
- 56c0a71f - GLX: Add a function to change a clients vendor list
- b4231d69 - GLX: Set GlxServerExports::{major,minor}Version

As of this writing, these commits are only in the master branch of the X.Org X server, and not yet in any official X.Org X server release.

Ubuntu 19.04 or 18.04 users can use an X server, with the above commits applied, from the PPA here: https://launchpad.net/~aplattner/+archive/ubuntu/ppa/



### Configure the X Screen

To use NVIDIA's PRIME render offload support, configure the X server with an X screen using an integrated GPU with the xf86-video-modesetting X driver. The X server will normally automatically do this, assuming the system BIOS is configured to boot on the iGPU, but to configure explicitly:

```
Section "ServerLayout"
  Identifier "layout"
  Screen 0 "iGPU"
EndSection

Section "Device"
  Identifier "iGPU"
  Driver "modesetting"
EndSection

Section "Screen"
  Identifier "iGPU"
  Device "iGPU"
EndSection
```

Also, confirm that the xf86-video-modesetting X driver is using "glamoregl". The log file `/var/log/Xorg.0.log` should contain something like this:

```
[1272173.618] (II) Loading sub module "glamoregl"
[1272173.618] (II) LoadModule: "glamoregl"
[1272173.618] (II) Loading /usr/lib/xorg/modules/libglamoregl.so
[1272173.622] (II) Module glamoregl: vendor="X.Org Foundation"
[1272173.622]   compiled for 1.20.4, module version = 1.0.1
[1272173.622]   ABI class: X.Org ANSI C Emulation, version 0.4
[1272173.638] (II) modeset(0): glamor X acceleration enabled on Mesa DRI Intel(R) HD Graphics 630 (Kaby Lake GT2)
[1272173.638] (II) modeset(0): glamor initialized
```

If glamoregl could not be loaded, the X log may report something like:

```
[1271802.673] (II) Loading sub module "glamoregl"
[1271802.673] (II) LoadModule: "glamoregl"
[1271802.673] (WW) Warning, couldn't open module glamoregl
[1271802.673] (EE) modeset: Failed to load module "glamoregl" (module does not exist, 0)
[1271802.673] (EE) modeset(0): Failed to load glamor module.
```

in which case, consult your distribution's documentation for how to (re-)install the package containing glamoregl.



### Configure the GPU Screen

Next, enable creation of NVIDIA GPU screens in the X server. This requires two things.

(1) Set the "AllowNVIDIAGPUScreens" X configuration option. E.g.,

```
Section "ServerLayout"
  Identifier "layout"
  Option "AllowNVIDIAGPUScreens"
EndSection
```

(2) Ensure that the nvidia-drm kernel module is loaded. This should normally happen by default, but you can confirm by running ``lsmod | grep nvidia-drm`` to see if the kernel module is loaded. Run ``modprobe nvidia-drm`` to load it.

If GPU screen creation was successful, the log file `/var/log/Xorg.0.log` should contain lines with "NVIDIA(G0)", and querying the RandR providers with ``xrandr --listproviders`` should display a provider named "NVIDIA-G0" (for "NVIDIA GPU screen 0").



### Configure Graphics Applications to Render Using the GPU Screen

To configure a graphics application to be offloaded to the NVIDIA GPU screen, set the environment variable `__NV_PRIME_RENDER_OFFLOAD` to `1`. If the graphics application uses Vulkan, that should be all that is needed. If the graphics application uses GLX, then also set the environment variable `__GLX_VENDOR_LIBRARY_NAME` to `nvidia`, so that GLVND loads the NVIDIA GLX driver. NVIDIA's EGL implementation does not yet support PRIME render offload.

Examples:

```
__NV_PRIME_RENDER_OFFLOAD=1 vkcube
__NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia glxinfo | grep vendor
```



### Finer-Grained Control of Vulkan

The `__NV_PRIME_RENDER_OFFLOAD` environment variable causes the special Vulkan layer `VK_LAYER_NV_optimus` to be loaded. Vulkan applications use the Vulkan API to enumerate the GPUs in the system and select which GPU to use; most Vulkan applications will use the first GPU reported by Vulkan. The `VK_LAYER_NV_optimus` layer causes the GPUs to be sorted such that the NVIDIA GPUs are enumerated first. For finer-grained control, the `VK_LAYER_NV_optimus` layer looks at the `__VK_LAYER_NV_optimus` environment variable. The value `NVIDIA_only` causes `VK_LAYER_NV_optimus` to only report NVIDIA GPUs to the Vulkan application. The value `non_NVIDIA_only` causes `VK_LAYER_NV_optimus` to only report non-NVIDIA GPUs to the Vulkan application.

Examples:

```
__NV_PRIME_RENDER_OFFLOAD=1 __VK_LAYER_NV_optimus=NVIDIA_only vkcube
__NV_PRIME_RENDER_OFFLOAD=1 __VK_LAYER_NV_optimus=non_NVIDIA_only vkcube
```



### Finer-Grained Control of GLX + OpenGL

For GLX + OpenGL, the environment variable `__NV_PRIME_RENDER_OFFLOAD_PROVIDER` provides finer-grained control. While `__NV_PRIME_RENDER_OFFLOAD=1` tells GLX to use the first NVIDIA GPU screen, `__NV_PRIME_RENDER_OFFLOAD_PROVIDER` can use an RandR provider name to pick a specific NVIDIA GPU screen, using the NVIDIA GPU screen names reported by ``xrandr --listproviders``.

Examples:

```
__NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia glxgears
__NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0 __GLX_VENDOR_LIBRARY_NAME=nvidia glxgears
```



------

| [Prev](https://download.nvidia.com/XFree86/Linux-x86_64/435.17/README/randr14.html) | [Up](https://download.nvidia.com/XFree86/Linux-x86_64/435.17/README/installationandconfiguration.html) | [Next](https://download.nvidia.com/XFree86/Linux-x86_64/435.17/README/kms.html) |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
| Chapter 34. Offloading Graphics Display with RandR 1.4       | [Home](https://download.nvidia.com/XFree86/Linux-x86_64/435.17/README/index.html) | Chapter 36. Direct Rendering Manager Kernel Modesetting (DRM KMS) |