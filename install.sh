#!/bin/bash

# Check if Script is Run as Root
if [[ $EUID -ne 0 ]]; then
  echo "You must be a root user to run this script, please run sudo ./install.sh" 2>&1
  exit 1
fi

# Change Debian to SID Branch
cp /etc/apt/sources.list /etc/apt/sources.list.bak
cp sources.list /etc/apt/sources.list

username=$(id -u -n 1000)
builddir=$(pwd)

# Update packages list and update system
apt update
apt upgrade -y

# Making .config and Moving config files and background to Pictures
cd $builddir
mkdir -p /home/$username/.config
mkdir -p /home/$username/.fonts
mkdir -p /home/$username/Pictures
mkdir -p /usr/share/sddm/themes
cp .Xresources /home/$username
cp .Xnord /home/$username
cp -R dotconfig/* /home/$username/.config/
cp bg.jpg /home/$username/Pictures/
mv user-dirs.dirs /home/$username/.config
chown -R $username:$username /home/$username
tar -xzvf sugar-candy.tar.gz -C /usr/share/sddm/themes
mv /home/$username/.config/sddm.conf /etc/sddm.conf

# Installing sugar-candy dependencies
apt install libqt5svg5 qml-module-qtquick-controls qml-module-qtquick-controls2 -y
# Installing Essential Programs 
apt install bspwm sxhkd kitty rofi polybar picom thunar nitrogen lxpolkit x11-xserver-utils unzip yad wget pulseaudio pavucontrol -y
# Installing Other less important Programs
apt install neofetch flameshot install psmisc mangohud vim lxappearance papirus-icon-theme lxappearance fonts-noto-color-emoji -y

# Add Custom Sddm Deb Package
dpkg -i 'deb-packages/sddm_0.19.0-4_amd64.deb'
apt install -f -y

# Download Nordic Theme
cd /usr/share/themes/
git clone https://github.com/EliverLara/Nordic.git

# Installing fonts
cd $builddir
apt install fonts-font-awesome
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/FiraCode.zip
unzip FiraCode.zip -d /home/$username/.fonts
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Meslo.zip
unzip Meslo.zip -d /home/$username/.fonts
mv dotfonts/fontawesome/otfs/*.otf /home/$username/.fonts/
chown $username:$username /home/$username/.fonts/*

# Reloading Font
fc-cache -vf
# Removing zip Files
rm ./FiraCode.zip ./Meslo.zip

# Install Nordzy cursor
git clone https://github.com/alvatip/Nordzy-cursors
cd Nordzy-cursors
./install.sh
cd $builddir
rm -rf Nordzy-cursors

# Install brave-browser
git clone https://github.com/djoma98/debian-brave
cd debian-brave
chmod +x install.sh
./install.sh
cd $builddir
rm -rf debian-brave

# Enable graphical login and change target from CLI to GUI
systemctl enable sddm
systemctl set-default graphical.target
