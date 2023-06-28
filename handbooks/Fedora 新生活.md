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

<http://cn.linux.vbird.org/linux_basic/0580backup.php>

推荐备份目录

```bash
/etc
/home
/usr/local
```

#### 0.2.1 rsync

```bash
today=$(date +%Y%m%d)
mkdir /mnt/data/backups/fedora-$(rpm -E %fedora)-$today/
sudo rsync -av /home /mnt/data/backups/fedora-$(rpm -E %fedora)-$today/
sudo rsync -av /etc /mnt/data/backups/fedora-$(rpm -E %fedora)-$today/
sudo rsync -av /usr/local /mnt/data/backups/fedora-$(rpm -E %fedora)-$today/usr/
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

### 0.3 备份各种列表

#### 0.3.1 导出已安装的软件包

```bash
# 所有已安装的软件列表
dnf list --installed > fedora-$(rpm -E %fedora)-$(date +%Y-%m-%d)-installed-list.txt
# 由用户安装的软件列表
dnf history userinstalled > fedora-$(rpm -E %fedora)-$(date +%Y-%m-%d)-user-installed-list.txt
# flatpak 包
flatpak list > fedora-$(rpm -E %fedora)-$(date +%Y-%m-%d)-flatpak-installed-list.txt
```

#### 0.3.2 导出命令历史

```bash
history > fedora-$(rpm -E %fedora)-$(date +%Y-%m-%d)-command-history.txt
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

<https://github.com/uunicorn/python-validity>

<https://gitter.im/Validity90/Lobby>

fedora pam_configuration:

<https://github.com/williamwlk/my-red-corner/blob/master/README_PAM.txt>

<https://computingforgeeks.com/how-to-setup-built-in-fingerprint-reader-authentication-with-pam-on-any-linux/>

<!-- ##### a. use Ubuntu:ppa & alien convert

http://ppa.launchpad.net/uunicorn/open-fprintd/ubuntu

https://www.tecmint.com/convert-from-rpm-to-deb-and-deb-to-rpm-package-using-alien/ -->

##### 1). use AUR

sudo dnf remove fprintd -y

tar -zxvf *.tar.gz

<https://aur.archlinux.org/packages/fprintd-clients/>

```bash
sudo dnf install -y libfprint-devel polkit-devel dbus-glib-devel systemd-devel pam-devel pam_wrapper meson patch
```

```bash
patch -Np1 < ../disable-systemd-reactivated.diff
meson . ./build
sudo meson install -C build
sudo install -d -m 700 /var/lib/fprint
```

<https://aur.archlinux.org/packages/open-fprintd/>

```bash
python setup.py build
sudo python setup.py install --prefix=/usr --root /
sudo install -D -m 644 debian/open-fprintd.service /usr/lib/systemd/system/open-fprintd.service
sudo install -D -m 644 debian/open-fprintd-resume.service /usr/lib/systemd/system/open-fprintd-resume.service
sudo install -D -m 644 debian/open-fprintd-suspend.service /usr/lib/systemd/system/open-fprintd-suspend.service
```

<https://aur.archlinux.org/packages/python-validity/>

```bash
sudo pip install pyyaml pyusb cryptography
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

<https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html-single/configuring_authentication_and_authorization_in_rhel/index>

```bash
sudo authselect select sssd
sudo authselect enable-feature with-fingerprint
```

### 1.3 美化

#### 1.3.1 grub

<https://github.com/suiahae/grub2-themes>

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

   ```conf
   # GRUB_TERMINAL_OUTPUT="console"
   ```

    增加 GRUB_SAVEDEFAULT="true" 保存上次启动项

   ```conf
   GRUB_SAVEDEFAULT="true"
   ```

4. 重新生成 grub.cfg

    ```bash
    sudo grub2-mkconfig -o /boot/grub2/grub.cfg
    ```

    Fedora 34 作了调整，UEFI 和 BIOS 都将使用 /boot/grub2/grub.cfg

    原本在 UEFI 下，其命令为`sudo grub2-mkconfig -o /boot/efi/EFI/fedora/grub.cfg`

##### 1.3.1.2 错误提示

1. `问题描述：`开机的时候报了一个错误 error: ../../grub-core/fs/fshelp.c:257:file /EFL/Fedora/locale/zh.gmo not found. 但不影响启动 grub 也能正常显示

    `解决方案：`根据网上的帖子 (<https://bugzilla.redhat.com/show_bug.cgi?id=817187#c42>)运行下面的命令使这个错误信息消失了

    ```bash
    sudo mkdir -p /boot/efi/EFI/fedora/locale
    sudo cp /usr/share/locale/zh_CN/LC_MESSAGES/grub.mo /boot/efi/EFI/fedora/locale/zh.gmo
    ```

    还有一个解决方法是在生成grub.cfg时把语言变量设置为英文：

    ```bash
    LANG=C grub2-mkconfig -o /boot/grub2/grub.cfg
    ```

2. `问题描述：`错误 “error: ../../grub-core/commands/loadenv.c:216:sparse file not allowed.”

    `解决方案` <https://forum.manjaro.org/t/grub-error-sparse-file-not-allowed/20267/4>

    暂时关闭“保存上次启动项”功能，编辑 /etc/default/grub

    原来：

    ```conf
    GRUB_SAVEDEFAULT="true"
    ```

    改为：

    ```conf
    # GRUB_SAVEDEFAULT="true"
    ```

##### 1.3.1.3 图标不显示

参考：<https://github.com/vinceliuice/grub2-themes/issues/100#issuecomment-722771012>

Fedora 的图标没有在 grub 中显示，甚至没有显示 Linux企鹅Tux图标。

> grub文档:
> The boot menu where GRUB displays the menu entries from the "grub.cfg" file. It is a list of items, where each item has a title and an optional icon. The icon is selected based on the classes specified for the menu entry. If there is a PNG file named "myclass.png" in the "grub/themes/icons" directory, it will be displayed for items which have the class "myclass"

奇怪的是，在Fedora中该类被设置为 "kernel"。

所以需要在主题文件夹创建从 fedora.png 到 kernel.png 的符号链接。重启即可看到图标。例如：

```bash
sudo ln -s /usr/share/grub/themes/Tela/icons/fedora.png /usr/share/grub/themes/Tela/icons/kernel.png
```

#### 1.3.2 gnome theme

https://github.com/suiahae/Simplify-Linux-deployment/blob/master/scripts/update-vimix-gtk-themes-online.sh

https://github.com/suiahae/Simplify-Linux-deployment/blob/master/scripts/update-Qogir-icon-online.sh

https://github.com/lassekongo83/adw-gtk3


<!-- #### 1.3.2 MaterialFox

https://github.com/muckSponge/MaterialFox/

https://github.com/muckSponge/MaterialFox/archive/v80.0.zip

********************

The following content is from MaterialFox-76.2, ==but it is very important==

2. [about:config] Set ```toolkit.legacyUserProfileCustomizations.stylesheets``` to ```true``` (default is ```false```).
3. [about:config] Set ```svg.context-properties.content.enabled``` to ```true``` (default is ```false```).

******************** -->

## 2. 推荐软件

### 2.1 代理软件

#### 2.1.1 Clash (deprecated, waiting update)

1. 克隆仓库

   ```bash
   https://github.com/suiahae/clash-premium-installer.git
   ```

2. 安装

   ```bash
   sudo clash-premium-installer/installer.sh install
   ```

3. 下载或创建配置文件 config.yaml

   一些帮助 [NetNodes_Informations.md]

   <https://gist.github.com/suiahae/bfbc87fedea21ef8760e1ff8f02a567f>

4. 创建 config.yaml 后，请将其权限更改为rw -------，以避免节点信息泄漏。

   ```bash
   chmod 600 /usr/local/etc/clash/*
   ```

5. 下载 [yacd](https://github.com/haishanh/yacd) 管理面板

   ```bash
   mkdir yacd-gh-pages && cd yacd-gh-pages
   https://github.com/haishanh/yacd/archive/gh-pages.zip
   unzip gh-pages.zip && rm -v gh-pages.zip
   ```

   打开 index.html 即可

#### 2.1.1 Clash for Windows

https://github.com/Fndroid/clash_for_windows_pkg

   ```bash
   flatpak install flathub io.github.Fndroid.clash_for_windows
   ```
   
[Service Mode not working on Flathub](https://github.com/Fndroid/clash_for_windows_pkg/issues/3298)

### 2.2 gnome 插件

从 [extensions.gnome.org](https://extensions.gnome.org/) 下载

[User Themes](https://extensions.gnome.org/extension/19/user-themes/)

[AppIndicator and KStatusNotifierItem Support](https://extensions.gnome.org/extension/615/appindicator-support/)

[GSConnect](https://extensions.gnome.org/extension/1319/gsconnect/)

需要 openssl

[Desktop Icons NG (DING)](https://extensions.gnome.org/extension/2087/desktop-icons-ng-ding/)

[Proxy Switcher](https://extensions.gnome.org/extension/771/proxy-switcher/)

[Removable Drive Menu](https://extensions.gnome.org/extension/7/removable-drive-menu/)

[Net speed Simplified](https://extensions.gnome.org/extension/3724/net-speed-simplified/)

[x11-gestures](https://extensions.gnome.org/extension/4033/x11-gestures/)

[Clipboard Indicator](https://extensions.gnome.org/extension/779/clipboard-indicator/)

[Dash to Panel](https://extensions.gnome.org/extension/1160/dash-to-panel/)

~~[Dash to Dock](https://extensions.gnome.org/extension/307/dash-to-dock/)~~

~~[Horizontal workspaces](https://extensions.gnome.org/extension/2141/horizontal-workspaces/)~~

~~[Input Method Panel](https://extensions.gnome.org/extension/261/kimpanel/)~~

### 2.3 系统工具

#### 2.3.1 thinkfan

<https://gist.github.com/suiahae/37fff654837e9959dacb39e5d0627369>

<https://www.cnblogs.com/henryau/archive/2012/03/03/ubuntu_thinkfan.html>

1. 安装

   ```bash
   sudo dnf install thinkfan -y
   ```

2. 安装内核模块

   ```bash
   sudo dnf install lm_sensors -y
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

   ==以下配置不适合 1.2.1==

   ```conf
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
   # (0, 0, 50)
   # (1, 50, 60)
   # (3, 60, 70)
   # (127, 70, 32767)
   (0, 0, 22)
   (1, 22, 33)
   (2, 33, 38)
   (3, 38, 44)
   (6, 44, 60)
   (64, 60, 70)
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
   sudo dnf install fcitx5 fcitx5-chinese-addons fcitx5-gtk fcitx5-qt fcitx5-configtool fcitx5-lua -y
   ```

2. 自动重启

   ```bash
   sudo dnf install fcitx5-autostart -y
   ```

<!-- 2. 添加系统变量自动重启

   ```bash
   sudo su
   cat > /etc/profile.d/fcitx5.sh << EOF
   export GTK_IM_MODULE=fcitx5
   export QT_IM_MODULE=fcitx5
   export XMODIFIERS="@im=fcitx5"
   EOF
   ```

3. 在 gnomes-tweaks 设置 fcitx5 开机启动 -->

##### 2.4.1.2 设置皮肤

<https://github.com/hosxy/Fcitx5-Material-Color>

两年没更新了，不过还能用

```bash
mkdir -p ~/.local/share/fcitx5/themes/Material-Color
git clone https://github.com/hosxy/Fcitx5-Material-Color.git ~/.local/share/fcitx5/themes/Material-Color
```

手动设置配色方案

```bash
cd ~/.local/share/fcitx5/themes/Material-Color
ln -sf ./theme-deepPurple.conf theme.conf
```

~~启用主题~~ (在附加组件里选一下主题就行，其他无需修改，已默认)

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

~~使用单行模式~~ (无需修改，已默认)

修改 `~/.config/fcitx5/conf/pinyin.conf`, 加入/修改以下内容：

```conf
# 可用时在应用程序中显示预编辑文本
PreeditInApplication=True
```

**注意**：修改配置文件 `~/.config/fcitx5/profile` 时，请务必退出 fcitx5 输入法，否则会因为输入法退出时会覆盖配置文件导致之前的修改被覆盖；修改其他配置文件可以不用退出 fcitx5 输入法，重启生效。

##### 2.4.1.2 启用词典

<https://github.com/felixonmars/fcitx5-pinyin-zhwiki/releases>

<https://github.com/outloudvi/mw2fcitx/releases>

下载词典文件至 Fcitx5 词典目录

```bash
mkdir -p ~/.local/share/fcitx5/pinyin/dictionaries
```

##### 2.4.1.3 更改快捷键符合 Windows 10/11 习惯

1. 解除系统 ibus 快捷键占用

   - “设置” -- “键盘” -- “键盘快捷键” -- “打字” -- 点一下之后按 “Backspace” -- 点设置

2. 更改 Fcitx 快捷键设置

   1. “配置” -- “输入法” -- 添加分组 “纯英语” -- 添加输入法 “键盘-汉语”
   
   2. “配置” -- “全局选项” -- 删掉 “切换启用/禁用输入法” 后的所有选项 -- 添加 “左 shift” 和 “右 shift”
   
   3. 删掉 “临时在当前和第一个输入法之间切换” 后的 “左 shift” 
   
### 2.5 文字编辑

#### 2.5.1 Visual Studio Code

<https://code.visualstudio.com/docs/setup/linux>

##### 2.5.1.1 安装

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

##### 2.5.1.2 个性化

1. 登陆 github/Micorsoft 同步设置

2. 将 window.titleBarStyle 改为 custom

#### 2.5.3 PyCharm-Community

<https://flathub.org/apps/details/com.jetbrains.PyCharm-Community>

```bash
# 安装flatpak
sudo dnf install flatpak -y
# 添加仓库
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
# 更换 flathub 镜像
sudo flatpak remote-modify flathub --url=https://mirror.sjtu.edu.cn/flathub
# 恢复默认
sudo flatpak remote-modify flathub --url=https://dl.flathub.org/repo/
# 安装
flatpak install flathub com.jetbrains.PyCharm-Community
# 命令运行或点击图标运行，运行命令如下：
flatpak run com.jetbrains.PyCharm-Community
```

#### 2.5.2 LaTeX

[overleaf](https://www.overleaf.com/)

https://www.latex-project.org/

https://www.tug.org/texlive/

http://ar.nyx.link/tex/utf8/

https://fedoraproject.org/wiki/Features/TeXLive

https://docs.fedoraproject.org/en-US/neurofedora/latex/

sudo dnf install texlive-scheme-full

sudo dnf install texlive

https://github.com/James-Yu/LaTeX-Workshop

sudo dnf install latexmk

[使用VSCode编写LaTeX](https://zhuanlan.zhihu.com/p/38178015)

[TexLive 2021 安装指南](https://www.bilibili.com/read/cv10635025/)

[万灵药 VS Code 的常用妙方之 LaTeX 写论文](https://baileyswu.github.io/2019/12/vscode-tutorials/)

#### 2.5.2 Okular

<https://apps.kde.org/okular/>

1. 对于 KDE，默认安装

2. 对于 GNOME，使用 Flatpak 安装

   ```bash
   # 安装
   flatpak install flathub org.kde.okular
   # 命令运行或点击图标运行，运行命令如下：
   flatpak run org.kde.okular
   ```

#### 2.5.2 Typora (Not FOSS)

<https://github.com/RPM-Outpost/typora>

#### 2.5.3 WPS

<https://linux.wps.cn/>

1. [From Flatpak](https://flathub.org/apps/details/com.wps.Office)

   ```bash
   # 安装
   flatpak install flathub com.wps.Office
   # 命令运行或点击图标运行，运行命令如下：
   flatpak run com.wps.Office
   ```

2. <https://linux.wps.cn/>

问题：字体缺失
解决方案：将 files/wps_symbol_fonts.zip 解压至 $HOME/.local/share/fonts 中。

#### 2.5.4 Marker (Only English)

A simple markdown editor for GTK+

```bash
sudo dnf install -y marker
```

<!-- #### 2.5.5 Remarkable

https://remarkableapp.github.io/index.html

```bash
sudo dnf install https://remarkableapp.github.io/files/remarkable-1.87-1.rpm
``` -->

#### 2.5.5 Mark Text (Only English before v1.0.0)

> [Internationalization of Mark Text · Issue #138 · marktext/marktext · GitHub](https://github.com/marktext/marktext/issues/138)

<https://marktext.app/>

1. [From Flatpak](https://flathub.org/apps/details/com.github.marktext.marktext)

   ```bash
   # 安装flatpak
   sudo dnf install flatpak -y
   # 添加仓库
   flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
   # 安装
   flatpak install flathub com.github.marktext.marktext
   # 命令运行或点击图标运行，运行命令如下：
   flatpak run com.github.marktext.marktext
   ```

2. [Releases · marktext/marktext · GitHub](https://github.com/marktext/marktext/releases)

### 2.6 虚拟机平台

#### 2.6.1 virt-manager

<!-- ```bash
dnf install qemu libvirt virt-manager -y
``` -->

<https://zh.fedoracommunity.org/2019/07/23/full-virtualization-system-on-fedora-workstation-30.html>

1. 安装软件包

   ```bash
   sudo dnf install @virtualization
   ```

2. 编辑 libvirtd 配置

   默认情况下，只有 root 用户才能进行系统管理，如果要为普通用户授权的话，则需要按以下步骤操作。

   编辑 /etc/libvirt/libvirtd.conf 这个文件。

   ```bash
   sudo vi /etc/libvirt/libvirtd.conf
   ```

   将域 socket 的所有组设置为 libvirt：

   ```conf
   unix_sock_group = "libvirt"
   ```

   修改 R/W socket 的 UNIX socket 权限：

   ```conf
   unix_sock_rw_perms = "0770"
   ```

3. 运行 libvirtd 服务并设置为开机自启

   ```bash
   sudo systemctl start libvirtd
   
   sudo systemctl enable libvirtd
   ```

4. 将用户添加到组

   如果想使用普通用户身份来管理 libvirt 的话，需要将该用户添加到 libvirt 组，不然的话每次启动虚拟管理器时，都得输入 sudo 密码。

   ```bash
   sudo usermod -a -G libvirt $(whoami)
   ```

   这一行命令就可以将当前用户添加到组。

   注意，这里需要注销后再登录才能生效。

#### 2.6.2 VMware

##### 2.6.2.1 安装 VMware

<https://www.vmware.com/go/downloadworkstation>

<!-- ##### 2.6.2.2 打内核补丁

https://docs.fedoraproject.org/en-US/quick-docs/how-to-use-vmware/

https://github.com/mkubecek/vmware-host-modules

依赖环境

```bash
sudo dnf install kernel-devel kernel-headers gcc gcc-c++ make git
```

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

<https://github.com/vmware/open-vm-tools/issues/427>

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

磁盘性能过差

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

5. 启用 sshd.service

   ```bash
   sudo systemctl enable sshd.service --now
   ```

6. 强制密钥登陆

   创建 /etc/ssh/sshd_config.d/99-[USER]-nopasswd.conf 文件，内容为：

   ```bash
   Match User [USER]
   PasswordAuthentication no
   ```

### 2.7-2 Git

```bash
git config --global user.name "yourname"
git config --global user.email "youremail"
```

### 2.8-1 视频播放

#### 2.8.1 emby

<https://github.com/MediaBrowser/Emby.Releases/releases/latest>

#### 2.8.2 Celluloid

Simple GTK+ frontend for mpv

<https://celluloid-player.github.io/>

```bash
sudo dnf install celluloid -y
```

<!-- #### 2.8.3 mpv -->

#### 2.8.3 vlc

### 2.8-2 音乐播放

#### 2.8.4 Spotify

[From Flatpak](https://flathub.org/apps/details/com.spotify.Client)

```bash
# 安装
flatpak install flathub com.spotify.Client
# 运行/点击图标运行
flatpak run com.spotify.Client
```

#### 2.8.4 网易云音乐

1. [From Flatpak](https://flathub.org/apps/details/com.netease.CloudMusic)

   ```bash
   # 安装flatpak
   sudo dnf install flatpak -y
   # 添加仓库
   flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
   # 安装netease.CloudMusic
   flatpak install flathub com.netease.CloudMusic
   # 运行/点击图标运行
   flatpak run com.netease.CloudMusic
   ```

2. API+gtk： [GitHub - gmg137/netease-cloud-music-gtk: Linux 平台下基于 Rust + GTK 开发的网易云音乐播放器](https://github.com/gmg137/netease-cloud-music-gtk)

3. [AUR (en) - netease-cloud-music](https://aur.archlinux.org/packages/netease-cloud-music/)

<!-- 2. [GitHub - xuthus5/fedora-netease: fedora网易云音乐安装脚本。该脚本用于在Fedora上一键安装网易云音乐，测试于Fedora-KDE-30。](https://github.com/xuthus5/fedora-netease) -->

#### 2.8.5 All in One Music

1. [GitHub - sunzongzheng/music: electron跨平台音乐播放器；可搜网易云、QQ音乐、虾米音乐；支持QQ、微博、Github登录，云歌单; 支持一键导入音乐平台歌单](https://github.com/sunzongzheng/music)

2. [AUR (en) - musiclake-git](https://aur.archlinux.org/packages/musiclake-git/)

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

`sudo gedit /etc/systemd/system/aria2.service`

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

<https://chrome.google.com/webstore/detail/aria2-for-chrome/mpkodccbngfoacfalldjimigbofkhgjn>

#### 2.11.2 motrix

<https://github.com/agalwood/Motrix/releases>

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
   vncpasswd
   ```

   as the user you will be starting the server for.

   **Note:**

   If you were using Tigervnc before for your user and you already created a password, then you will have to make sure the `$HOME/.vnc` folder created by `vncpasswd` will have the correct *SELinux* context. You either can delete this folder and recreate it again by creating the password one more time, or alternatively you can run

   ```bash
   restorecon -RFv /home/[USER]/.vnc
   ```

3. 创建 systemd-user-service

   <http://www.jinbuguo.com/systemd/systemd.service.html>

   `/home/[USER]/.config/systemd/user/vncserver-<username>.service`

   ```conf
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
      sudo loginctl enable-linger $(whoami)
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

<https://community.teamviewer.com/English/kb/articles/6318-how-to-install-teamviewer-for-linux>

1. 导入key

   ```bash
   sudo rpm --import https://download.teamviewer.com/download/linux/signature/TeamViewer2017.asc
   ```

2. 安装

   ```bash
   sudo dnf install https://download.teamviewer.com/download/linux/teamviewer.x86_64.rpm
   ```

#### 2.12.3 AnyDesk

<http://rpm.anydesk.com/howto.html>

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

<https://github.com/xyou365/AutoRclone/blob/master/Readme.md>
<https://gsuitems.com/index.php/archives/13/>

#### 2.13.2 Rclone

##### 2.13.2.1 安装 Rclone

```bash
sudo dnf install rclone -y
```

依照官方文档配置 Rclone

<https://rclone.org/drive/>

<https://www.80tm.com/2020/04/10/debian-ubuntu用rclone挂载google-drive团队盘/>

Notes: 注意编辑`/etc/fuse.conf`文件 ---- “取消注释 user_allow_other”以允许非root用户挂载。

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

#### 2.13.3 samba

fedora samba

1. install samba

   ```bash
   sudo dnf install smaba -y
   ```

2. change config file
   backup `sudo cp smb.conf smb.conf.bak`
   add follow context to /etc/samba/smb.conf

   ```bash
   sudo gedit /etc/samba/smb.conf
   ......
   [global]
   ......
   ......
   [Arder]
      comment = Arder Directories
   path = /home/samba_test_user
   browseable = yes
   writable = yes
   write list = samba_test_user
   ```

3. Run 'testparm' to verify the config is correct after you modified it.

4. Create 'samba_test_user', and lock the account. Or use current user.

   ```bash
   sudo useradd samba_test_user
   sudo passwd --lock samba_test_user
   ```

   Set a Samba Password for this Test User (such as 'test'):

   ```bash
   sudo smbpasswd -a samba_test_user
   ```

5. Set on SELinux rules

   5.1 view the SELinux rules about samba

   ```bash
   ~]# getsebool -a | grep samba
   samba_domain_controller --> off
   samba_enable_home_dirs --> off   <==开放用户使用home目录
   samba_export_all_ro --> off      <==允许只读文件系统的功能
   samba_export_all_rw --> off      <==允许读写文件系统的功能
   samba_share_fusefs --> off       <==允许读写ntfs/fusefs文件系统的功能
   samba_share_nfs --> off
   use_samba_home_dirs --> off      <==类似用户home目录的开放！
   virt_use_samba --> off
   ```

   5.2 set the rules we need to on

   ```bash
   sudo setsebool -P samba_enable_home_dirs=1
   sudo setsebool -P samba_export_all_ro=1
   sudo setsebool -P samba_export_all_rw=1
   sudo setsebool -P samba_share_fusefs=1
   ```

6. Configuring your firewall to enable Samba to pass through.

   ```bash
   Allow Samba access through the firewall:
   ~]# firewall-cmd --add-service=samba --permanent
   ~]# firewall-cmd --reload

   Verify Samba is included in your active firewall:
   ~]$ firewall-cmd --list-services

   Output (should include):
   samba
   ```

7. Enable and Start Services

   ```bash
   sudo systemctl enable smb.service
   sudo systemctl start smb.service
   # Verify smb service:
   systemctl status smb.service
   ```

8. Addition: make samba follow symlink outside the shared path

   ```bash
   sudo gedit /etc/samba/smb.conf
   ......
   [global]
   ......
   allow insecure wide links = yes
   ......
   [Arder]
   ......
   follow symlinks = yes
   wide links = yes
   ```

<https://fedoramagazine.org/fedora-32-simple-local-file-sharing-with-samba/>
<http://linux.vbird.org/linux_server/0370samba.php>
<https://unix.stackexchange.com/questions/5120/how-do-you-make-samba-follow-symlink-outside-the-shared-path>

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

实用教程：<https://suiahae.me/docker-tutorial-1/>

1. 安装最新版 [Moby Engine](https://mobyproject.org/)

   ```bash
   sudo dnf install docker
   ```

2. 开启docker.service

   ```bash
   sudo systemctl start docker
   ```

3. 验证Docker是否已正确安装

   ```bash
   sudo docker info
   ```

<!-- 2. Cgroups Exception: 对于Fedora 31及更高版本，需要为Cgroups启用向后兼容。

    ```bash
    sudo grubby --update-kernel=ALL --args="systemd.unified_cgroup_hierarchy=0"
    ``` -->

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

[2]: 专为 `138a:0097` (例如 ThinkPad T470)
