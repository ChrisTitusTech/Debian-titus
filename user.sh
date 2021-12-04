#!/bin/bash

# Appearance pacakges
sudo apt install papirus-icon-theme lxappearance fonts-noto-color-emoji fonts-firacode fonts-font-awesome libqt5svg5 qml-module-qtquick-controls

# Make Theme folders
mkdir -p ~/.themes ~/.fonts

# Fira Code Nerd Font variant needed
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/FiraCode.zip
unzip FiraCode.zip -d ~/.fonts
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Meslo.zip
unzip Meslo.zip -d ~/.fonts   
fc-cache -vf

#Ms-fonts
sudo apt install ttf-mscorefonts-installer

# Layan Cursors
cd "$HOME/build"
git clone https://github.com/vinceliuice/Layan-cursors
cd Layan-cursors
sudo ./install.sh

# if people want doas 
 sudo apt install build-essential make bison flex libpam0g-dev 
git clone https://github.com/slicer69/doas.git
cd doas/
mkdir build && cd build 
sudo make install

echo "RUN LXAPPEARANCE"

cp .Xresources ~
cp .Xnord ~
cp -R dotfiles/* ~/.config/
