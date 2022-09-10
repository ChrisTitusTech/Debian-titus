#!/bin/bash

# Change Debian to SID Branch
cp /etc/apt/sources.list /etc/apt/sources.list.bak
cp sources.list /etc/apt/sources.list


username=$(id -u -n 1000)
builddir=$(pwd)

# Add Custom Titus Rofi Deb Package
dpkg -i 'Custom Packages/rofi_1.7.0-1_amd64.deb'

# Update packages list
apt update

# Add base packages
apt install unzip picom bspwm polybar sddm rofi kitty thunar flameshot neofetch sxhkd git lxpolkit pulseaudio pavucontrol xorg -y
apt install papirus-icon-theme feh lxappearance fonts-noto-color-emoji fonts-firacode fonts-font-awesome libqt5svg5 qml-module-qtquick-controls qml-module-qtquick-controls2 yad -y

# Download Nordic Theme
cd /usr/share/themes/
git clone https://github.com/EliverLara/Nordic.git

# Fira Code Nerd Font variant needed
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v1.1.0/FiraCode.zip
unzip FiraCode.zip -d /usr/share/fonts
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v1.1.0/Meslo.zip
unzip Meslo.zip -d /usr/share/fonts
fc-cache -vf

cd $builddir
mkdir -p /home/$username/.config
mkdir -p /home/$username/Pictures
mkdir -p /usr/share/sddm/themes
cp .Xresources /home/$username
cp .Xnord /home/$username
cp -R dotfiles/* /home/$username/.config/
cp background.jpg /home/$username/Pictures/
chown -R $username:$username /home/$username
tar -xzvf sugar-candy.tar.gz -C /usr/share/sddm/themes
cp dotfiles/sddm.conf /etc/sddm.conf 
