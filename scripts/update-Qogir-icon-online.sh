#!/bin/bash
# notify-send "Qogir-icon-theme" "Getting the latest version of the Qogir icon theme..." -i system-software-update; 
# sudo dnf install p7zip
# sudo apt install p7zip
# sudo pacman -S p7zip-full

# mkdir .tmp 2>/dev/null; 
# cd .tmp; 
cd /tmp;
rm -Rf Qogir-icon-theme.zip 2>/dev/null; 
rm -Rf Qogir-icon-theme-master/ 2>/dev/null; 
wget https://github.com/vinceliuice/Qogir-icon-theme/archive/2020-06-22.zip -O Qogir-icon-theme.zip; 
7za x Qogir-icon-theme.zip; 
cd Qogir-icon-theme-2020-06-22; 
./install.sh; 
cd ..;
rm -Rf Qogir-icon-theme.zip 2>/dev/null; 
rm -Rf Qogir-icon-theme-2020-06-22/ 2>/dev/null; 
# notify-send "All done!" "Enjoy the latest version of Qogir!" -i face-smile
