# https://mirrors.tuna.tsinghua.edu.cn/
# https://extensions.gnome.org/
# https://rpmfusion.org/Howto/NVIDIA
proxytype="http";
proxyhost="192.168.160.1";
proxyport="7890";
proxyaddress=$proxytype"://"$proxyhost":"$proxyport;


export http_proxy=$proxyaddress;
export https_proxy=$proxyaddress;

# export http_proxy=http://192.168.43.1:1080;
# export https_proxy=http://192.168.43.1:1080;

chmod +x scripts/*;

sudo dnf install redhat-lsb-core;

lsb_release -a > /tmp/lsb_release_grep;
distributor=$(grep -oP '(?<=Distributor ID:\s)\w*' /tmp/lsb_release_grep);
distri_ubuntu='Ubuntu';
distri_fedora='Fedora';
distri_arch='Arch Linux';

# 改变镜像源
if [ "$distributor" = "$distri_ubuntu" ];
then
    ./scripts/change-update-list-ubuntu.sh;
    sudo apt update && sudo apt upgrade;
elif [ "$distributor" = "$distri_fedora" ];
then
    ./scripts/change-update-list-fedora.sh;
    sudo dnf makecache;
    sudo dnf update
elif [ "$distributor" = "$distri_arch" ];
then
    echo $distri_arch;
fi

# 安装环境

sudo apt install git p7zip-full zsh wget curl make;
sudo dnf install git p7zip zsh wget curl make util-linux-user
sudo pacman -S git p7zip zsh wget curl make;

# 安装 proxychains
./scripts/install-proxychains.sh;
# 更改 proxychains 代理
sudo sed -i "s/^socks.*/http\t192.168.160.1\t7890/g" /etc/proxychains.conf;
sudo sed -i "s/^socks.*/$proxytype\t$proxyhost\t$proxyport/g" /etc/proxychains.conf;
#sudo echo "http\t192.168.43.1\t1080" >> /etc/proxychains.conf;
echo "alias pycs=proxychains4" >> ~/.bashrc;

# 安装主题
sudo apt install gnome-tweak-tool;
sudo dnf install gnome-tweak-tool;
sudo pacman -S gnome-tweak-tool;

./scripts/update-Qogir-theme-online.sh;
./scripts/update-Vimix-gtk-themes-online.sh;

# 安装 oh-my-zsh
# sudo dnf install util-linux-user;
sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)";
chsh -s $(which zsh)
# 下载插件
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting;
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions;
# 更改 plugins 配置
sed -i 's/plugins=(.*/plugins=(vim-interaction pip git sudo extract z wd archlinux zsh-autosuggestions zsh-syntax-highlighting)/g' ~/.zshrc;
sed -i 's/ZSH_THEME=".*/ZSH_THEME="ys"/g' ~/.zshrc;
echo "alias pycs=proxychains4" >> ~/.zshrc;
