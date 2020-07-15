# https://github.com/muckSponge/MaterialFox/
# sudo dnf install p7zip
# sudo apt install p7zip
# sudo pacman -S p7zip-full
 
cd /tmp;
rm -Rf MaterialFox 2>/dev/null;
rm -Rf /home/minux/.mozilla/firefox/0fg92z41.default-release/chrome 2>/dev/null;
git clone https://github.com/muckSponge/MaterialFox.git;
mv MaterialFox/chrome /home/minux/.mozilla/firefox/0fg92z41.default-release; 
rm -Rf MaterialFox 2>/dev/null;
# notify-send "All done!" "Enjoy the latest version of Vimix!" -i face-smile
