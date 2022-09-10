#!/bin/bash

# Appearance pacakges

#Ms-fonts
sudo apt install ttf-mscorefonts-installer

# Layan Cursors
mkdir -p $HOME/build
cd "$HOME/build"
git clone https://github.com/vinceliuice/Layan-cursors
cd Layan-cursors
sudo ./install.sh
cd ../
sudo mkdir -p /usr/share/icons/default/
echo "[Icon Theme]" | sudo tee /usr/share/icons/default/index.theme > /dev/null
echo "Inherits=Layan-cursors" | sudo tee -a /usr/share/icons/default/index.theme > /dev/null
# Powermenu Unicode problem fix
git clone https://github.com/adi1090x/rofi.git
mkdir -p $HOME/.local/share/fonts
cp -rf rofi/fonts/* $HOME/.local/share/fonts/
