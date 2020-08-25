#!/bin/bash
# notify-send "Orchis-theme" "Getting the latest version of the Orchis theme..." -i system-software-update; 
# sudo dnf install p7zip
# sudo apt install p7zip
# sudo pacman -S p7zip-full

# mkdir .tmp 2>/dev/null; 
# cd .tmp; 
cd /tmp;
rm -Rf Orchis-theme.zip 2>/dev/null; 
rm -Rf Orchis-theme-master/ 2>/dev/null; 
wget https://github.com/vinceliuice/Orchis-theme/archive/master.zip -O Orchis-theme.zip; 
7za x Orchis-theme.zip; 
cd Orchis-theme-master; 
./install.sh; 
cd ..;
rm -Rf Orchis-theme.zip 2>/dev/null; 
rm -Rf Orchis-theme-master/ 2>/dev/null; 
# notify-send "All done!" "Enjoy the latest version of Orchis!" -i face-smile
