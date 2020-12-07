#!/bin/bash
# notify-send "WhiteSur-gtk-theme" "Getting the latest version of the WhiteSur-gtk-theme..." -i system-software-update; 
# sudo dnf install p7zip
# sudo apt install p7zip
# sudo pacman -S p7zip-full
sudo dnf install gtk-murrine-engine gtk2-engines sassc optipng inkscape glib2-devel

# Rounded Dash to Dock: https://gist.github.com/suiahae/744be70c9d6944bfb4d67b3a54ec9efd

# mkdir .tmp 2>/dev/null; 
# cd .tmp;
cd /tmp;
rm -Rf WhiteSur-gtk-theme.zip 2>/dev/null; 
rm -Rf WhiteSur-gtk-theme-2020-12-03/ 2>/dev/null; 
wget https://github.com/vinceliuice/WhiteSur-gtk-theme/archive/2020-12-03.zip -O WhiteSur-gtk-theme.zip; 
7za x WhiteSur-gtk-theme.zip; 
cd WhiteSur-gtk-theme-2020-12-03; 
./install.sh; 
# Install GDM theme
sudo ./install.sh -g;
# #revert GDM theme
# sudo ./install.sh -r;
cd ..;
rm -Rf WhiteSur-gtk-theme.zip 2>/dev/null; 
rm -Rf WhiteSur-gtk-theme-2020-12-03/ 2>/dev/null; 
# notify-send "All done!" "Enjoy the latest version of WhiteSur!" -i face-smile

cd /tmp;
rm -Rf WhiteSur-icon-theme.zip 2>/dev/null; 
rm -Rf WhiteSur-icon-theme-master/ 2>/dev/null; 
wget https://github.com/vinceliuice/WhiteSur-icon-theme/archive/2020-10-11.zip -O WhiteSur-icon-theme.zip; 
7za x WhiteSur-icon-theme.zip; 
cd WhiteSur-icon-theme-2020-10-11; 
./install.sh; 
cd ..;
rm -Rf WhiteSur-icon-theme.zip 2>/dev/null; 
rm -Rf WhiteSur-icon-theme-2020-10-11/ 2>/dev/null; 
# notify-send "All done!" "Enjoy the latest version of WhiteSur!" -i face-smile
mkdir -p $HOME/.local/share/backgrounds
wget https://github.com/vinceliuice/WhiteSur-kde/raw/master/wallpaper/WhiteSur_4k.png -O $HOME/.local/share/backgrounds/WhiteSur_4k.png