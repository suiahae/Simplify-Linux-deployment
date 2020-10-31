#!/bin/bash
# notify-send "vimix-gtk-themes" "Getting the latest version of the Vimix themes..." -i system-software-update; 
# sudo dnf install p7zip
# sudo apt install p7zip
# sudo pacman -S p7zip-full

# mkdir .tmp 2>/dev/null; 
# cd .tmp; 
cd /tmp;
rm -Rf vimix-gtk-themes.zip 2>/dev/null; 
rm -Rf vimix-gtk-themes-master/ 2>/dev/null; 
wget https://github.com/vinceliuice/vimix-gtk-themes/archive/2020-02-24.zip -O vimix-gtk-themes.zip; 
7za x vimix-gtk-themes.zip; 
cd vimix-gtk-themes-2020-02-24; 
./install.sh; 
cd ..;
rm -Rf vimix-gtk-themes.zip 2>/dev/null; 
rm -Rf vimix-gtk-themes-2020-02-24/ 2>/dev/null; 
# notify-send "All done!" "Enjoy the latest version of Vimix!" -i face-smile
