# Fedora 新生活

代理设置

## 镜像源更改

from [rpmfusion.org](https://rpmfusion.org/Configuration)

```bash
sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
```

from [rpm sphere](https://rpmsphere.github.io/)
```bash
sudo dnf install https://github.com/rpmsphere/noarch/raw/master/r/rpmsphere-release-32-1.noarch.rpm
```

系统更新

驱动安装
nvidia

必要软件安装
zsh&&oh-my-zsh
oh-my-zsh插件下载
zsh配置更改
alias别名设置

[typora rpm](https://github.com/RPM-Outpost/typora)

系统美化
软件安装

主题下载

[插件下载](https://extensions.gnome.org/)

User Themes
Dash to Dock
[Dash to Panel](https://github.com/home-sweet-gnome/dash-to-panel)
Desktop Icons NG (DING)
Proxy Switcher
NetSpeed by hedayaty
KStatusNotifierItem/AppIndicator Support
TopIcons Plus by phocean
Clipboard Indicator by Tudmotu

## 软件

docker
docker-compose
clash
yacd

seahorse

便签：xpad

### 视频播放

rclone
Autorclone(添加图标 alacarte)
[emby](https://github.com/MediaBrowser/Emby.Releases/releases)

vlc

mpv

### 虚拟机平台

dnf install qemu libvirt virt-manager

#### VMware

启用 3D 加速

vim .vmware/preferences

mks.gl.allowBlacklistedDrivers = "TRUE"

### 系统工具

thinkfan

https://gist.github.com/suiahae/37fff654837e9959dacb39e5d0627369
https://www.cnblogs.com/henryau/archive/2012/03/03/ubuntu_thinkfan.html

[Visual Studio Code on Linux](https://code.visualstudio.com/docs/setup/linux)

fcitx

[皮肤文件转换](https://github.com/VOID001/ssf2fcitx) [搜狗皮肤下载](https://pinyin.sogou.com/skins/)

~/.config/fcitx/skin
[词库](https://www.cnblogs.com/luoshuitianyi/p/11669619.html)
~/.config/fcitx/pinyin

### 图片浏览器

nomacs

### 截图工具

flameshot

### 下载工具

[motrix](https://github.com/agalwood/Motrix/releases)

uGet
--enable-rpc=true -D --disable-ipv6 --check-certificate=false --all-proxy="http://127.0.0.1:7890" --conf-path=~/.config/aria2/aria2.conf

aria2

### ssh

登陆

```
ssh user@linux_sever
```

生成密钥

```
ssh-keygen -t rsa -C "comment"
```

查看公钥

```
cat ~/.ssh/id_rsa.pub
```

用ssh-copy-id将公钥复制到远程机器的`~/.ssh/authorized_keys`中

```
ssh-copy-id -i ～/.ssh/id_rsa.pub user@linux_sever
```

### 远程桌面/VNC

安装软件

```
sudo dnf install tigervnc-server tigervnc
```

设置密码

You need to set a password for each user in order to be able to start the 
Tigervnc server. In order to create a password, you just run

```
$ vncpasswd
```

as the user you will be starting the server for. 

**Note:**

If you were using Tigervnc before for your user and you already created a password, then you will have to make sure the `$HOME/.vnc` folder created by `vncpasswd` will have the correct *SELinux* context. You either can delete this folder and recreate it again by creating the password one more time, or alternatively you can run

```
$ restorecon -RFv /home/<USER>/.vnc
```

创建用户 systemd.unit

`/home/minux/.config/systemd/user/vncserver-minux.service`

```
[Unit]
Description=Remote desktop service (VNC) for Minux
After=syslog.target network.target

[Service]
Type=simple
ExecStart=/usr/bin/x0vncserver -display :1 -passwordfile /home/minux/.vnc/passwd -Geometry 1920x1080 -localhost

[Install]
WantedBy=multi-user.target
```

此时监听端口为`5900`

**Note:** 

`-localhost` 应与 ssh 一起使用

```
ssh user@linux_sever -L 8900:localhost:5900
vncviewer localhost:8900
```

重载

```
systemctl --user daemon-reload
```

测试

```
systemctl --user start vncserver-minux.service 
```

测试无误默认开启

```
systemctl --user enable vncserver-minux.service
```

客户端连接

```
vncviewer linux_sever:5800
```



