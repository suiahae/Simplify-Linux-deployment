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

rclone
Autorclone(添加图标 alacarte)
[emby](https://github.com/MediaBrowser/Emby.Releases/releases)

vlc

mpv

[Visual Studio Code on Linux](https://code.visualstudio.com/docs/setup/linux)

dnf install qemu libvirt virt-manager

vim .vmware/preferences

mks.gl.allowBlacklistedDrivers = "TRUE"

## fcitx

[皮肤文件转换](https://github.com/VOID001/ssf2fcitx) [搜狗皮肤下载](https://pinyin.sogou.com/skins/)

~/.config/fcitx/skin
[词库](https://www.cnblogs.com/luoshuitianyi/p/11669619.html)
~/.config/fcitx/pinyin

## 图片浏览器

nomacs

## 截图工具

flameshot

## 下载工具

[motrix](https://github.com/agalwood/Motrix/releases)

uGet
--enable-rpc=true -D --disable-ipv6 --check-certificate=false --all-proxy="http://127.0.0.1:7890" --conf-path=~/.config/aria2/aria2.conf

aria2
