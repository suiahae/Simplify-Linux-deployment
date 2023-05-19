#!/bin/bash
# notify-send "vimix-gtk-themes" "Getting the latest version of the Vimix themes..." -i system-software-update; 
# sudo dnf install p7zip
# sudo apt install p7zip
# sudo pacman -S p7zip-full

VGT_VERSION="2023-03-23";

# mkdir .tmp 2>/dev/null; 
# cd .tmp; 
cd /tmp;
rm -Rf vimix-gtk-themes* 2>/dev/null; 
wget https://github.com/vinceliuice/vimix-gtk-themes/archive/refs/tags/$VGT_VERSION.zip -O vimix-gtk-themes.zip; 
7za x vimix-gtk-themes.zip; 
cd vimix-gtk-themes-*; 
mkdir -p $HOME/.local/share/themes
./install.sh -t doder; 
# Link installed gtk-4.0 theme to config folder for all libadwaita app use this Vimix-light-doder
./install.sh -t doder -c light -l; 
cd ..; 
rm -Rf vimix-gtk-themes-* 2>/dev/null; 
# notify-send "All done!" "Enjoy the latest version of Vimix!" -i face-smile
