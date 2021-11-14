# Debian-titus
Debian customizations from Chris Titus Tech
 
## Requirements

### Base Stuff

_Run as ROOT_
```
apt install bspwm polybar sddm rofi kitty thunar flameshot neofetch sxhkd git lxpolkit lxappearance xorg

# Download Nordic Theme
cd /usr/share/themes/
git clone https://github.com/EliverLara/Nordic.git
mkdir -p /usr/share/sddm/themes/Nordic
cp Nordic/kde/sddm/* /usr/share/sddm/themes/Nordic/

# Make SDDM Config
cat <<EOF > /etc/sddm.conf
[Theme]
Current=Nordic
EOF
```

### Theme Stuff
```
sudo apt install papirus-icon-theme lxappearance fonts-noto-color-emoji fonts-firacode fonts-font-awesome libqt5svg5 qml-module-qtquick-controls

# Make Theme folders
mkdir -p ~/.themes ~/.fonts

# Fira Code Nerd Font variant needed
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/FiraCode.zip
unzip FiraCode.zip ~/.fonts
fc-cache -vf

# Layan Cursors
cd ~/build
git clone https://github.com/vinceliuice/Layan-cursors
cd Layan-cursors
sudo ./install.sh
```
