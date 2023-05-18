#!/bin/bash
# notify-send "Vimix Icon Theme" "Getting the latest version of the Vimix Icon Theme..." -i system-software-update; 
# sudo dnf install p7zip
# sudo apt install p7zip
# sudo pacman -S p7zip-full

VIT_VERSION="2023-01-18";

# mkdir .tmp 2>/dev/null; 
# cd .tmp; 
cd /tmp;
rm -Rf vimix-icon-theme.zip 2>/dev/null; 
rm -Rf vimix-icon-theme-master/ 2>/dev/null; 
wget https://github.com/vinceliuice/vimix-icon-theme/archive/refs/tags/$VIT_VERSION.zip -O vimix-icon-theme.zip; 
7za x vimix-icon-theme.zip; 
cd vimix-icon-theme-*; 
./install.sh -n doder; 
cd ..;
rm -Rf vimix-icon-theme.zip 2>/dev/null; 
rm -Rf vimix-icon-theme-*/ 2>/dev/null; 
# notify-send "All done!" "Enjoy the latest version of Vimix!" -i face-smile
