#!/bin/bash
# notify-send "adw-gtk3-themes" "Getting the latest version of the adw-gtk3 themes..." -i system-software-update; 

AG3_VERSION="v5.7";

cd /tmp;

mkdir -p $HOME/.local/share/themes/;

wget https://github.com/lassekongo83/adw-gtk3/releases/download/$AG3_VERSION/adw-gtk3$AG3_VERSION.tar.xz -O adw-gtk3$AG3_VERSION.tar.xz;
tar -xvJf adw-gtk3$AG3_VERSION.tar.xz -C $HOME/.local/share/themes/;

cd ..;
rm -Rf adw-gtk3$AG3_VERSION.tar.xz 2>/dev/null;
# notify-send "All done!" "Enjoy the latest version of adw-gtk3!" -i face-smile;
