#!/bin/bash
# notify-send "Qogir-theme" "Getting the latest version of the Qogir theme..." -i system-software-update; 
# sudo dnf install p7zip
# sudo apt install p7zip
# sudo pacman -S p7zip-full

# mkdir .tmp 2>/dev/null; 
# cd .tmp; 
cd /tmp;
rm -Rf Qogir-theme.zip 2>/dev/null; 
rm -Rf Qogir-theme-master/ 2>/dev/null; 
wget https://github.com/vinceliuice/Qogir-theme/archive/2020-11-16.zip -O Qogir-theme.zip; 
7za x Qogir-theme.zip; 
cd Qogir-theme-2020-11-16; 
./install.sh; 
cd ..;
rm -Rf Qogir-theme.zip 2>/dev/null; 
rm -Rf Qogir-theme-2020-11-16/ 2>/dev/null; 
# notify-send "All done!" "Enjoy the latest version of Qogir!" -i face-smile
