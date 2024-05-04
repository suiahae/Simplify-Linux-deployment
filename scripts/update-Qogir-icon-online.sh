#!/bin/bash
# notify-send "Qogir Icon Theme" "Getting the latest version of the Qogir Icon Theme..." -i system-software-update; 
# sudo dnf install p7zip
# sudo apt install p7zip
# sudo pacman -S p7zip-full

QIT_VERSION="2023-06-05";

# mkdir .tmp 2>/dev/null; 
# cd .tmp; 
cd /tmp;
rm -Rf Qogir-icon-theme* 2>/dev/null; 
wget https://github.com/vinceliuice/Qogir-icon-theme/archive/refs/tags/$QIT_VERSION.zip -O Qogir-icon-theme.zip; 
7za x Qogir-icon-theme.zip; 
cd Qogir-icon-theme-*; 
./install.sh; 
cd ..;
rm -Rf Qogir-icon-theme* 2>/dev/null; 
# notify-send "All done!" "Enjoy the latest version of Qogir!" -i face-smile
