# Fedora 新生活

## 0. 系统规划与准备

### 0.1 分区

```bash
/boot/efi   200MiB
/boot       1GiB
swap        20GiB
/           remain
```

### 0.2 重装前备份

http://cn.linux.vbird.org/linux_basic/0580backup.php

推荐备份目录

```bash
/etc
/home
/usr/local
```

#### 0.2.1 rsync

```bash
sudo rsync -av /home /mnt/data/backups/fedora/
sudo rsync -av /etc /mnt/data/backups/fedora/
sudo rsync -av /usr/local /mnt/data/backups/fedora/usr/
```

```bash
# 将 /etc 文件夹同步至 /mnt/data/rsync/fedora/ （创建 etc 文件夹）
rsync -av /etc /mnt/data/rsync/fedora/
# 将 /etc 内容同步至 /mnt/data/rsync/fedora/ （不创建 etc 文件夹）
rsync -av /etc/ /mnt/data/rsync/fedora/
```

```bash
[root@www ~]# rsync [-avrlptgoD] [-e ssh] [user@host:/dir] [/local/path]
选项与参数：
-v ：观察模式，可以列出更多的信息，包括镜像时的档案档名等；
-q ：与 -v  相反，安静模式，略过正常信息，仅显示错误讯息；
-r ：递归复制！可以针对『目录』来处理！很重要！
-u ：仅更新 (update)，若目标档案较新，则保留新档案不会覆盖；
-l ：复制链接文件的属性，而非链接的目标源文件内容；
-p ：复制时，连同属性 (permission) 也保存不变！
-g ：保存源文件的拥有群组；
-o ：保存源文件的拥有人；
-D ：保存源文件的装置属性 (device)
-t ：保存源文件的时间参数；
-I ：忽略更新时间 (mtime) 的属性，档案比对上会比较快速；
-z ：在数据传输时，加上压缩的参数！
-e ：使用的信道协议，例如使用 ssh 通道，则 -e ssh
-a ：相当于 -rlptgoD ，所以这个 -a 是最常用的参数了！
更多说明请参考 man rsync！
```

#### 0.2.2 tar （不推荐）

1. 备份命令

    ```bash
    sudo su
    tar -cvpzf /mnt/data/backups/home_backup@`date +%Y-%m-%d`.tar.gz /home
    tar -cvpzf /mnt/data/backups/etc_backup@`date +%Y-%m-%d`.tar.gz /etc
    tar -cvpzf /mnt/data/backups/usr_local_backup@`date +%Y-%m-%d`.tar.gz /usr/local
    ```

2. 解压

    ```bash
    sudo su
    tar -xvpzf /mnt/data/backups/home_backup*.tar.gz /home
    tar -xvpzf /mnt/data/backups/etc_backup*tar.gz /etc
    tar -xvpzf /mnt/data/backups/usr_local_backup*.tar.gz /usr/local
    ```

## 1. 初始化配置

### 1.1 使用脚本

使用配置脚本初始化配置。

```bash
git clone https://github.com/suiahae/Simplify-Linux-deployment.git
cd Simplify-Linux-deployment/
./start.sh
```

以上仓库包括 `代理配置`、`软件仓库配置`、`工具下载`、`美化`、`别名设置`，按需修改。

**Note:**

1. 解决 zsh “zsh: no matches found *”

    ```bash
    echo "setopt no_nomatch" >> ~/.zshrc
    source ~/.zshrc
    ```

### 1.2 安装驱动

#### 1.2.1 NVIDIA [1]

```bash
sudo dnf update -y # 如果不是最新的内核，请重新启动
sudo dnf install akmod-nvidia 
sudo dnf install xorg-x11-drv-nvidia-cuda #可选启用 cuda/nvdec/nvenc 支持
```

#### 1.2.2 fprintd-clients open-fprintd python-validity [2]

https://github.com/uunicorn/python-validity

https://gitter.im/Validity90/Lobby

fedora pam_configuration: 
https://github.com/williamwlk/my-red-corner/blob/master/README_PAM.txt

https://computingforgeeks.com/how-to-setup-built-in-fingerprint-reader-authentication-with-pam-on-any-linux/

<!-- ##### a. use Ubuntu:ppa & alien convert

http://ppa.launchpad.net/uunicorn/open-fprintd/ubuntu

https://www.tecmint.com/convert-from-rpm-to-deb-and-deb-to-rpm-package-using-alien/ -->

##### use AUR

sudo dnf remove fprintd -y

tar -zxvf *.tar.gz

https://aur.archlinux.org/packages/fprintd-clients-git/

```bash
sudo dnf install -y libfprint-devel polkit-devel dbus-glib-devel systemd-devel pam-devel pam_wrapper meson patch
```

```bash
patch -Np1 < ../disable-systemd-reactivated.diff
meson . ./build
sudo meson install -C build
sudo install -d -m 700 /var/lib/fprint
```

https://aur.archlinux.org/packages/open-fprintd/

```bash
python setup.py build
sudo python setup.py install --prefix=/usr --root /
sudo install -D -m 644 debian/open-fprintd.service /usr/lib/systemd/system/open-fprintd.service
sudo install -D -m 644 debian/open-fprintd-resume.service /usr/lib/systemd/system/open-fprintd-resume.service
sudo install -D -m 644 debian/open-fprintd-suspend.service /usr/lib/systemd/system/open-fprintd-suspend.service
```

https://aur.archlinux.org/packages/python-validity/

```bash
sudo pip install pyyaml pyusb
python setup.py build
sudo python setup.py install --prefix=/usr --root /
sudo install -D -m 644 debian/python3-validity.service /usr/lib/systemd/system/python3-validity.service
sudo install -D -m 644 debian/python3-validity.udev /usr/lib/udev/rules.d/60-python-validity.rules
```

```bash
sudo systemctl start open-fprintd.service
sudo systemctl enable open-fprintd-suspend.service
sudo systemctl enable open-fprintd-resume.service
sudo systemctl start python3-validity.service

systemctl status open-fprintd.service
systemctl status python3-validity.service
```

```bash
fprintd-enroll
```

##### last but not least

```bash
sudo authselect enable-feature with-fingerprint
```

### 1.3 美化

#### 1.3.1 grub

https://github.com/suiahae/grub2-themes

##### 1.3.1.1 安装 grub2-themes 主题

1. 克隆仓库

    ```bash
    git clone https://github.com/suiahae/grub2-themes.git
    cd grub2-theme
    ```

2. 安装

    ```bash
    sudo ./install.sh -t
    ```

3. 更改 /etc/default/grub

    ```bash
    sudo gedit /etc/default/grub
    ```

    注释掉 GRUB_TERMINAL_OUTPUT="console"（这个控制是以哪种方式显示，不注释的话会以console窗口显示启动列表）

    ```
    # GRUB_TERMINAL_OUTPUT="console"
    ```

    增加 GRUB_SAVEDEFAULT="true" 保存上次启动项

    ```
    GRUB_SAVEDEFAULT="true"
    ```

##### 1.3.1.2 错误提示

`问题描述：`开机的时候报了一个错误 error: ../../grub-core/fs/fshelp.c:257:file /EFL/Fedora/locale/zh.gmo not found. 但不影响启动 grub 也能正常显示

`解决方案：`根据网上的帖子 (https://bugzilla.redhat.com/show_bug.cgi?id=817187#c42)运行下面的命令使这个错误信息消失了

```bash
sudo mkdir -p /boot/efi/EFI/fedora/locale
sudo cp /usr/share/locale/zh_CN/LC_MESSAGES/grub.mo /boot/efi/EFI/fedora/locale/zh.gmo
```

还有一个解决方法是在生成grub.cfg时把语言变量设置为英文：

```bash
LANG=C grub2-mkconfig -o /boot/grub2/grub.cfg
```

#### 1.3.2 MaterialFox

https://github.com/muckSponge/MaterialFox/

https://github.com/muckSponge/MaterialFox/archive/v80.0.zip

********************

The following content is from MaterialFox-76.2, ==but it is very important==

2. [about:config] Set ```toolkit.legacyUserProfileCustomizations.stylesheets``` to ```true``` (default is ```false```).
3. [about:config] Set ```svg.context-properties.content.enabled``` to ```true``` (default is ```false```).

********************

## 2. 推荐软件

### 2.1 代理软件

#### 2.1.1 Clash

1. 克隆仓库

   ```bash
   https://github.com/suiahae/clash-premium-installer.git
   ```

2. 安装

   ```bash
   sudo clash-premium-installer/installer.sh install
   ```

3. 创建 config.yaml 后，请将其权限更改为rw -------，以避免节点信息泄漏。

   ```bash
   chmod 600 /usr/local/etc/clash/*
   ```

4. 下载 [yacd](https://github.com/haishanh/yacd) 管理面板

   ```bash
   mkdir yacd-gh-pages && cd yacd-gh-pages
   https://github.com/haishanh/yacd/archive/gh-pages.zip
   unzip gh-pages.zip && rm -v gh-pages.zip
   ```

   打开 index.html 即可

### 2.2 gnome 插件

[插件下载](https://extensions.gnome.org/)

[Clipboard Indicator](https://extensions.gnome.org/extension/779/clipboard-indicator/)

[Dash to Panel](https://extensions.gnome.org/extension/1160/dash-to-panel/)

[Desktop Icons NG (DING)](https://extensions.gnome.org/extension/2087/desktop-icons-ng-ding/)

[AppIndicator and KStatusNotifierItem Support](https://extensions.gnome.org/extension/615/appindicator-support/)

[Proxy Switcher](https://extensions.gnome.org/extension/771/proxy-switcher/)

[TopIcons Plus](https://extensions.gnome.org/extension/1031/topicons/)

~~[Dash to Dock](https://extensions.gnome.org/extension/307/dash-to-dock/)~~

~~[Horizontal workspaces](https://extensions.gnome.org/extension/2141/horizontal-workspaces/)~~

~~[Input Method Panel](https://extensions.gnome.org/extension/261/kimpanel/)~~

### 2.3 系统工具

#### 2.3.1 thinkfan

https://gist.github.com/suiahae/37fff654837e9959dacb39e5d0627369
https://www.cnblogs.com/henryau/archive/2012/03/03/ubuntu_thinkfan.html

1. 安装

    ```bash
    sudo dnf install thinkfan -y
    ```

2. 安装内核模块

   ```bash
   sudo dnf -y install lm_sensors
   sudo sensors-detect --auto
   ```

3. 加载模块

   ```bash
   sudo systemctl restart systemd-modules-load
   ```

4. 更改 thinkfan.conf 

   ```bash
   sudo gedit /etc/thinkfan.conf
   ```

   ```
   ######################################################################
   # thinkfan 0.7 example config file
   # ================================
   #
   # ATTENTION: There is only very basic sanity checking on the configuration.
   # That means you can set your temperature limits as insane as you like. You
   # can do anything stupid, e.g. turn off your fan when your CPU reaches 70°C.
   #
   # That's why this program is called THINKfan: You gotta think for yourself.
   #
   ######################################################################
   #
   # IBM/Lenovo Thinkpads (thinkpad_acpi, /proc/acpi/ibm)
   # ====================================================
   #
   # IMPORTANT:
   #
   # To keep your HD from overheating, you have to specify a correction value for
   # the sensor that has the HD's temperature. You need to do this because
   # thinkfan uses only the highest temperature it can find in the system, and
   # that'll most likely never be your HD, as most HDs are already out of spec
   # when they reach 55 °C.
   # Correction values are applied from left to right in the same order as the
   # temperatures are read from the file.
   #
   # For example:
   # tp_thermal /proc/acpi/ibm/thermal (0, 0, 10)
   # will add a fixed value of 10 °C the 3rd value read from that file. Check out
   # http://www.thinkwiki.org/wiki/Thermal_Sensors to find out how much you may
   # want to add to certain temperatures.

   #  Syntax:
   #  (LEVEL, LOW, HIGH)
   #  LEVEL is the fan level to use (0-7 with thinkpad_acpi)
   #  LOW is the temperature at which to step down to the previous level
   #  HIGH is the temperature at which to step up to the next level
   #  All numbers are integers.
   #

   # I use this on my T61p:
   #tp_fan /proc/acpi/ibm/fan
   #tp_thermal /proc/acpi/ibm/thermal (0, 10, 15, 2, 10, 5, 0, 3, 0, 3)

   (0, 0, 50)
   (1, 50, 60)
   (3, 60, 70)
   (127, 70, 32767)
   ```

5. 启用 thinkfan service

   ```bash
   sudo systemctl enable thinkfan --now
   ```

6. 设置 thinkfan service 自动重启

   ```bash
   sudo su
   mkdir -p /etc/systemd/system/thinkfan.service.d
   cat > /etc/systemd/system/thinkfan.service.d/10-restart-on-failure.conf << EOF
   [Unit]
   StartLimitIntervalSec=30
   StartLimitBurst=3

   [Service]
   Restart=on-failure
   RestartSec=3
   EOF
   ```

7. 重载 systemd

   ```bash
   sudo systemctl daemon-reload
   ```

#### 2.3.2 timeshift

备份

```bash
sudo dnf install timeshift -y
```

#### 2.3.3 GNOME 菜单编辑器

```bash
sudo dnf install alacarte -y
```

#### 2.3.4 密钥管理

```bash
sudo dnf install seahorse -y
```

#### 2.3.5 grub

```bash
sudo dnf install grub-customizer -y
```

### 2.4 输入法

#### 2.4.1 Fcitx5

##### 2.4.1.1 安装 Fcitx5

1. 安装

    ```bash
    sudo dnf install fcitx5 fcitx5-chinese-addons fcitx5-gtk fcitx5-qt fcitx5-configtool -y
    ```

2. 添加系统变量

    ```bash
    sudo su
    cat > /etc/profile.d/fcitx5.sh << EOF
    export GTK_IM_MODULE=fcitx5
    export QT_IM_MODULE=fcitx5
    export XMODIFIERS="@im=fcitx5"
    EOF
    ```

3. 在 gnomes-tweaks 设置 fcitx5 开机启动

##### 2.4.1.2 设置皮肤

https://github.com/hosxy/Fcitx5-Material-Color

```bash
mkdir -p ~/.local/share/fcitx5/themes/Material-Color
git clone https://github.com/hosxy/Fcitx5-Material-Color.git ~/.local/share/fcitx5/themes/Material-Color
```

手动设置配色方案

```bash
cd ~/.local/share/fcitx5/themes/Material-Color
ln -sf ./theme-deepPurple.conf theme.conf
```

启用主题

```bash
cat > ~/.config/fcitx5/conf/classicui.conf << EOF
# 垂直候选列表
Vertical Candidate List=False
# 按屏幕 DPI 使用
PerScreenDPI=True
# 使用鼠标滚轮翻页
WheelForPaging=True
# Font
Font="思源黑体 CN Medium 10"
# 主题
Theme=Material-Color
EOF
```

使用单行模式，

修改 `~/.config/fcitx5/conf/pinyin.conf`, 加入/修改以下内容：

```
# 可用时在应用程序中显示预编辑文本
PreeditInApplication=True
```

**注意**：修改配置文件 `~/.config/fcitx5/profile` 时，请务必退出 fcitx5 输入法，否则会因为输入法退出时会覆盖配置文件导致之前的修改被覆盖；修改其他配置文件可以不用退出 fcitx5 输入法，重启生效。

##### 2.4.1.2 启用词典

https://github.com/felixonmars/fcitx5-pinyin-zhwiki/releases

https://github.com/outloudvi/mw2fcitx/releases

下载词典文件至 Fcitx5 词典目录

```bash
mkdir -p ~/.local/share/fcitx5/pinyin/dictionaries
```

### 2.5 文字编辑

#### 2.5.1 Visual Studio Code

https://code.visualstudio.com/docs/setup/linux

1. 安装 key and repository:

    ```bash
    sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
    sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
    ```

2. 更新缓存并安装 Visual Studio Code

    ```bash
    dnf check-update
    sudo dnf install code
    ```

#### 2.5.2 Typora

https://github.com/RPM-Outpost/typora

#### 2.5.3 WPS

https://linux.wps.cn/

#### 2.5.4 Marker

A simple markdown editor for GTK+

```bash
sudo dnf install -y marker
```

### 2.6 虚拟机平台

#### 2.6.1 qemu+libvirt

```bash
dnf install -y qemu libvirt virt-manager
```

#### 2.6.2 VMware

##### 2.6.2.1 安装 VMware

https://www.vmware.com/go/downloadworkstation

<!-- ##### 2.6.2.2 打内核补丁

https://github.com/mkubecek/vmware-host-modules

1. 克隆补丁

    ```bash
    git clone https://github.com/mkubecek/vmware-host-modules.git
    cd vmware-host-modules
    git checkout workstation-16.0.0
    ```

2. 创建内核tar文件

    ```bash
    tar -cf vmmon.tar vmmon-only
    tar -cf vmnet.tar vmnet-only
    ```

3. 将文件复制到/usr/lib/vmware.modules.source (需要root权限)

    ```bash
    sudo cp -v vmmon.tar vmnet.tar /usr/lib/vmware/modules/source/
    ```

4. 安装模块

    ```bash
    sudo vmware-modconfig --console --install-all
    ``` -->

##### 2.6.2.3 启用 3D 加速

```bash
cat >> ~/.vmware/preferences << EOF
mks.gl.allowBlacklistedDrivers = "TRUE"
EOF
```

##### 2.6.2.4 启用主机与虚拟机间的文件复制
https://github.com/vmware/open-vm-tools/issues/427

```bash
sudo su
systemctl enable run-vmblock\\x2dfuse.mount
systemctl start run-vmblock\\x2dfuse.mount
systemctl status -l run-vmblock\\x2dfuse.mount
```

##### 2.6.2.5 解决虚拟机桌面随机冻结

请从默认的Wayland X协议切换到X11协议。
登录到桌面时，单击登录屏幕右下角的小菜单，然后选择“ Xorg上的Gnome”。 

#### 2.6.3 VirtualBox

```bash
sudo dnf install VirtualBox -y
```

### 2.7 ssh

1. 登陆

    ```bash
    ssh user@linux_sever
    ```

2. 生成密钥

    ```bash
    ssh-keygen -t rsa -C "comment"
    ```

3. 查看公钥

    ```bash
    cat ~/.ssh/id_rsa.pub
    ```

4. 用ssh-copy-id将公钥复制到远程机器的`~/.ssh/authorized_keys`中

    ```bash
    ssh-copy-id -i ~/.ssh/id_rsa.pub user@linux_sever
    ```

### 2.7-2 Git

```bash
git config --global user.name "yourname"
git config --global user.email "youremail"
```

### 2.8 视频播放

#### 2.8.1 emby

https://github.com/MediaBrowser/Emby.Releases/releases/latest

#### 2.8.2 Celluloid

Simple GTK+ frontend for mpv

https://celluloid-player.github.io/ 

```bash
sudo dnf install celluloid -y
```

#### 2.8.3 vlc

#### 2.8.4 mpv

### 2.9 图片浏览器

#### 2.9.1 nomacs

```bash
sudo dnf install nomacs -y
```

### 2.10 截图工具

#### 2.10.1 flameshot

1. 安装

    ```bash
    sudo dnf install flameshot -y
    ```

2. 配置快捷键

    在`设置>键盘快捷键`添加自定义快捷键，命令为`flameshot gui`

### 2.11 下载工具

#### 2.11.1 aria2

##### 2.11.1.1 安装 aria2

```bash
sudo dnf install aria2 -y
```

##### 2.11.1.2 建立配置文件

配置文件目录 `~/.config/aria2/`

配置文件路径 `~/.config/aria2/aria2.conf`

##### 2.11.1.3 设置 systemd service

`sudo gedit /usr/lib/systemd/system/aria2.service`

```bash
[Unit]
Description=A utility for downloading files which supports HTTP(S), FTP, SFTP, BitTorrent and Metalink
Wants=clash.service
After=clash.service

[Service]
Type=simple
User=minux
ExecStart=/usr/bin/aria2c --enable-rpc=true --disable-ipv6 --check-certificate=false --all-proxy="http://127.0.0.1:7890" --conf-path=/home/minux/.config/aria2/aria2.conf

[Install]
WantedBy=multi-user.target
```

```bash
sudo systemctl enable aria2.service --now
```

##### 2.11.1.4 AriaNg 

Aria2 for Chrome

https://chrome.google.com/webstore/detail/aria2-for-chrome/mpkodccbngfoacfalldjimigbofkhgjn

#### 2.11.2 motrix

https://github.com/agalwood/Motrix/releases

#### 2.11.3 uGet

```bash
--enable-rpc=true -D --disable-ipv6 --check-certificate=false --all-proxy="http://127.0.0.1:7890" --conf-path=~/.config/aria2/aria2.conf
```

### 2.12 远程桌面

#### 2.12.1 VNC

1. 安装软件

    ```bash
    sudo dnf install tigervnc-server tigervnc -y
    ```

2. 设置密码

    You need to set a password for each user in order to be able to start the Tigervnc server. In order to create a password, you just run

    ```bash
    $ vncpasswd
    ```

    as the user you will be starting the server for. 

    **Note:**

    If you were using Tigervnc before for your user and you already created a password, then you will have to make sure the `$HOME/.vnc` folder created by `vncpasswd` will have the correct *SELinux* context. You either can delete this folder and recreate it again by creating the password one more time, or alternatively you can run

    ```bash
    $ restorecon -RFv /home/<USER>/.vnc
    ```

3. 创建 systemd-user-service 

    http://www.jinbuguo.com/systemd/systemd.service.html

    `/home/<USER>/.config/systemd/user/vncserver-<username>.service`

    ```
    [Unit]
    Description=Remote desktop service (VNC) for <username>
    After=syslog.target network.target

    [Service]
    Type=simple
    ExecStart=/usr/bin/x0vncserver -display :1 -passwordfile /home/<username>/.vnc/passwd -Geometry 1920x1080 -localhost
    Restart=on-failure
    RestartSec=5s

    [Install]
    WantedBy=graphical-session.target
    ```

    此时监听端口为`5900`

    **Note:** 

    1. `-localhost` 应与 ssh 一起使用

    ```bash
    ssh user@linux_sever -L 8900:localhost:5900
    vncviewer localhost:8900
    ```

    2. 为使 systemd-user-service 可以开机运行，需要以管理员身份启用此功能。[参考](https://serverfault.com/questions/739451/systemd-user-service-doesnt-autorun-on-user-login)

    ```bash
    sudo loginctl enable-linger <username>
    ```

    重载

    ```bash
    systemctl --user daemon-reload
    ```

    测试

    ```bash
    systemctl --user start vncserver-minux.service 
    ```

    测试无误默认开启

    ```bash
    systemctl --user enable vncserver-minux.service
    ```

    客户端连接

    ```bash
    vncviewer linux_sever:5800
    ```

#### 2.12.2 Teamviewer

1. 导入key

    ```bash
    sudo rpm --import https://download.teamviewer.com/download/linux/signature/TeamViewer2017.asc
    ```

2. 安装

    ```bash
    sudo dnf install https://download.teamviewer.com/download/linux/teamviewer.x86_64.rpm
    ```

#### 2.12.3 AnyDesk

http://rpm.anydesk.com/howto.html

1. 导入仓库

    ```bash
    sudo su
    cat > /etc/yum.repos.d/AnyDesk-Fedora.repo << "EOF" 
    [anydesk]
    name=AnyDesk Fedora - stable
    baseurl=http://rpm.anydesk.com/fedora/$basearch/
    gpgcheck=1
    repo_gpgcheck=1
    gpgkey=https://keys.anydesk.com/repos/RPM-GPG-KEY
    EOF
    dnf check-update
    ```

2. 安装

    ```bash
    sudo dnf install anydesk
    ```

### 2.13 网盘

#### 2.13.1 Autorclone (添加图标 alacarte)

1. 安装 rclone

    ```bash
    sudo dnf install screen git rclone -y
    ```

2. 克隆仓库并安装python依赖包

    ```bash
    git clone https://github.com/xyou365/AutoRclone && cd AutoRclone && pip install -r requirements.txt --user
    ```

3. 详细教程

https://github.com/xyou365/AutoRclone/blob/master/Readme.md
https://gsuitems.com/index.php/archives/13/

#### 2.13.2 Rclone

##### 2.13.2.1 安装 Rclone

```bash
sudo dnf install rclone -y
```

依照官方文档配置 Rclone

https://rclone.org/drive/

##### 2.13.2.2 通过 systemd service 实现开机自动挂载

例如：

`sudo vim /usr/lib/systemd/system/rclone-movies.service`

GDTeam_raye_movies

```bash
[Unit]
Description=Rclone mount gdteam movies
Wants=clash.service
After=clash.service

[Service]
Type=simple
User=minux
Environment="HTTPS_PROXY=http://127.0.0.1:7890"
ExecStart=/bin/rclone mount GDTeam_raye_movies: /home/emby/GDTeam_raye_movies --allow-other --allow-non-empty

[Install]
WantedBy=multi-user.target
```

### 2.14 其他工具

#### 2.14.1 xpad

便签

```bash
sudo dnf install xpad -y
```

#### 2.14.2 Foliate

简洁现代的电子书查看器

```bash
sudo dnf install foliate -y
```

#### 2.14.3 Qalculate

计算器

```bash
sudo dnf install qalculate -y
```

#### 2.14.4 SimpleScreenRecorder

录屏

```bash
sudo dnf install simplescreenrecorder -y
```

#### 2.14.5 Wine

```bash
sudo dnf install wine -y
```

#### 2.14.6 dnf 使用技巧

```bash
rpm -i software-2.3.4.rpm --nodeps
rpm -e software-2.3.4.rpm --nodeps
sudo sh -c 'echo "exclude=fprintd" >> /etc/dnf/dnf.conf'
```

### 2.15 容器

#### 2.15.1 docker

实用教程：https://suiahae.me/docker-tutorial-1/

1. 安装最新版 [Moby Engine](https://mobyproject.org/)

    ```bash
    sudo dnf install docker
    ```

<!-- 2. Cgroups Exception: 对于Fedora 31及更高版本，需要为Cgroups启用向后兼容。

    ```bash
    sudo grubby --update-kernel=ALL --args="systemd.unified_cgroup_hierarchy=0"
    ``` -->

2. 开启docker.service

   ```bash
   sudo systemctl start docker
   ```

3. 验证Docker是否已正确安装

    ```bash
    sudo docker info
    ```

### 2.16 游戏平台

#### 2.16.1 Steam

```bash
sudo dnf install steam -y
```

#### 2.16.2 Lutris

```bash
sudo dnf install lutris -y
```

[1]: 专为 NVIDIA

[2]: 专为 `138a:0097` (such as ThinkPad 470)
