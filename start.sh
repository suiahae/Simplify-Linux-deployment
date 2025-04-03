# https://mirrors.tuna.tsinghua.edu.cn/
# https://extensions.gnome.org/
# https://rpmfusion.org/Howto/NVIDIA

proxyhost="127.0.0.1";
proxytype="http";
proxyport="7890";
proxyaddress=$proxytype"://"$proxyhost":"$proxyport;

export http_proxy=$proxyaddress;
export https_proxy=$proxyaddress;

# export http_proxy=http://127.0.0.1:1080;
# export https_proxy=http://127.0.0.1:1080;

chmod +x scripts/*;

# sudo dnf install redhat-lsb-core -y;

# lsb_release -a > /tmp/lsb_release_grep;
# distributor=$(grep -oP '(?<=Distributor ID:\s)\w*' /tmp/lsb_release_grep);
# distri_fedora='Fedora';
# distri_ubuntu='Ubuntu';
# distri_arch='Arch Linux';

# if [ "$distributor" != "$distri_fedora" ];
# then
#     print("Your system is not Fedora")
#     exit
# fi
# https://tylersguides.com/guides/using-a-proxy-with-dnf/
# echo proxy=$proxyaddress | sudo tee -a /etc/dnf/dnf.conf

## 安装 proxychains-ng
# sudo apt install proxychains4 2>/dev/null;
# sudo dnf install proxychains-ng -y 2>/dev/null;

## 更改 proxychains 代理
# sudo sed -i "s/^socks.*/http\t192.168.160.1\t7890/g" /etc/proxychains.conf;
# sudo sed -i "s/^socks.*/$proxytype\t$proxyhost\t$proxyport/g" /etc/proxychains.conf;

# 安装 gg (go-graft)
sudo sh -c "$(curl -L https://github.com/mzz2017/gg/raw/main/release/go.sh)";
# 设置节点
gg config -w node=$proxyaddress;

# 改变镜像源
# if [ "$distributor" = "$distri_ubuntu" ];
# then
    # ./scripts/change-update-list-ubuntu.sh; # for Ubuntu 20.04 LTS
    # sudo apt update && sudo apt upgrade;
# elif [ "$distributor" = "$distri_fedora" ];
# then
    # # 更改为清华镜像源（https://mirrors.tuna.tsinghua.edu.cn/）
    # ./scripts/change-update-list-fedora.sh;
    # sudo dnf makecache;
    
    # 添加 https://rpmfusion.org/Configuration
    sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y;
    sudo dnf upgrade -y;
# elif [ "$distributor" = "$distri_arch" ];
# then
#     echo $distri_arch;
#     # 为 arch 安装 proxychains-ng
#     ./scripts/install-proxychains-ng.sh;
# fi

## 安装主题
# sudo apt install gnome-extensions-app gnome-tweak-tool p7zip-full wget -y; 
sudo dnf install gnome-extensions-app gnome-tweak-tool p7zip wget -y; 

# proxychains4 ./scripts/update-Qogir-theme-online.sh;
./scripts/update-Qogir-icon-online.sh;
./scripts/update-vimix-gtk-themes-online.sh;

## 在 Flatpak 应用程序上应用 GTK 主题 [[itsfoss](https://itsfoss.com/flatpak-app-apply-theme/)]，例如：
sudo flatpak override --filesystem=$HOME/.themes;
sudo flatpak override --filesystem=$HOME/.local/share/icons;
sudo flatpak override --env=GTK_THEME=vimix-light-doder;
sudo flatpak override --env=ICON_THEME=Qogir;

# 恢复默认
# sudo flatpak override --reset


# 安装环境
# sudo apt install git zsh wget -y; 
sudo dnf install git zsh wget util-linux-user -y; 

# 安装 oh-my-zsh
sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)";
# sudo chsh -s $(which zsh)  ${USER}
# 如果上句话不起作用，请手动更改 /etc/passwd

# 下载插件
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting;
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions;
git clone https://github.com/bilelmoussaoui/flatpak-zsh-completion ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/flatpak;

# 更改 plugins 配置
sed -i 's/plugins=(.*/plugins=(vim-interaction pip git sudo extract z wd archlinux zsh-autosuggestions zsh-syntax-highlighting flatpak command-not-found)/g' ~/.zshrc;
sed -i 's/ZSH_THEME=".*/ZSH_THEME="ys"/g' ~/.zshrc;

# 安装 sqlite 以支持 zsh command-not-found
sudo dnf install sqlite -y; 

# 设置别名
# echo "alias pycs=proxychains" >> ~/.zshrc;
# echo "alias supycs='sudo proxychains'" >> ~/.zshrc;

# zsh setting for gg
sed -i '1i\autoload -Uz compinit\ncompinit' ~/.zshrc
echo "unalias gg
compdef _precommand gg
" >> ~/.zshrc;

echo "alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'" >> ~/.zshrc;


source ~/.zshrc
