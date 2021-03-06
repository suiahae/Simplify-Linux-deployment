# https://mirrors.tuna.tsinghua.edu.cn/
# https://extensions.gnome.org/
# https://rpmfusion.org/Howto/NVIDIA

proxytype="http";
proxyhost="127.0.0.1";
proxyport="7890";
proxyaddress=$proxytype"://"$proxyhost":"$proxyport;

# export http_proxy=$proxyaddress;
# export https_proxy=$proxyaddress;

# export http_proxy=http://192.168.43.1:1080;
# export https_proxy=http://192.168.43.1:1080;

chmod +x scripts/*;

sudo dnf install redhat-lsb-core -y 2>/dev/null;

lsb_release -a > /tmp/lsb_release_grep;
distributor=$(grep -oP '(?<=Distributor ID:\s)\w*' /tmp/lsb_release_grep);
distri_ubuntu='Ubuntu';
distri_fedora='Fedora';
# distri_arch='Arch Linux';

# 安装 proxychains-ng
sudo apt install proxychains4 2>/dev/null;
sudo dnf install proxychains -y 2>/dev/null;

# 更改 proxychains 代理
#sudo sed -i "s/^socks.*/http\t192.168.160.1\t7890/g" /etc/proxychains.conf;
sudo sed -i "s/^socks.*/$proxytype\t$proxyhost\t$proxyport/g" /etc/proxychains.conf;

# 改变镜像源
if [ "$distributor" = "$distri_ubuntu" ];
then
    ./scripts/change-update-list-ubuntu.sh; # for Ubuntu 20.04 LTS
    sudo apt update && sudo apt upgrade;
elif [ "$distributor" = "$distri_fedora" ];
then
    # # 更改为清华镜像源（https://mirrors.tuna.tsinghua.edu.cn/）
    # ./scripts/change-update-list-fedora.sh;
    # sudo dnf makecache;
    # 添加 rpmfusion.org
    sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y;
    sudo dnf upgrade -y;
# elif [ "$distributor" = "$distri_arch" ];
# then
#     echo $distri_arch;
#     # 为 arch 安装 proxychains-ng
#     ./scripts/install-proxychains-ng.sh;
fi

## 安装主题
sudo apt install gnome-tweak-tool p7zip-full wget -y 2>/dev/null; 
sudo dnf install gnome-tweak-tool p7zip wget -y 2>/dev/null; 

# proxychains4 ./scripts/update-Qogir-theme-online.sh;
proxychains4 ./scripts/update-Qogir-icon-online.sh;
proxychains4 ./scripts/update-Vimix-gtk-themes-online.sh;

# 安装环境
sudo apt install git zsh wget -y 2>/dev/null; 
sudo dnf install git zsh wget util-linux-user -y 2>/dev/null; 

# 安装 oh-my-zsh
sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)";
# sudo chsh -s $(which zsh)  ${USER}
# 如果上句话不起作用，请手动更改 /etc/passwd

# 下载插件
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting;
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions;
# 更改 plugins 配置
sed -i 's/plugins=(.*/plugins=(vim-interaction pip git sudo extract z wd archlinux zsh-autosuggestions zsh-syntax-highlighting)/g' ~/.zshrc;
sed -i 's/ZSH_THEME=".*/ZSH_THEME="ys"/g' ~/.zshrc;

# 设置别名
echo "alias pycs=proxychains4" >> ~/.zshrc;
echo "alias supycs='sudo proxychains4'" >> ~/.zshrc;
echo "alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'" >> ~/.zshrc;
