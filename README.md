# Debian-titus
Debian customizations from Chris Titus Tech
 
## Requirements

### Base Stuff - Root

*Debian Sid* /etc/apt/sources.list (example)
```
deb http://deb.debian.org/debian/ sid main non-free contrib
deb-src http://deb.debian.org/debian/ sid main non-free contrib
```

_Run as ROOT_
```
apt install bspwm polybar sddm rofi kitty thunar flameshot neofetch sxhkd git lxpolkit lxappearance xorg
```

### Theme Stuff - User Level
```
sudo apt install papirus-icon-theme lxappearance fonts-noto-color-emoji fonts-firacode fonts-font-awesome libqt5svg5 qml-module-qtquick-controls

# Make Theme folders
mkdir -p ~/.themes ~/.fonts

# Fira Code and Meslo Nerd Font variant needed
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/FiraCode.zip
unzip FiraCode.zip -d ~/.fonts
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Meslo.zip
unzip Meslo.zip -d ~/.fonts   
fc-cache -vf

# Layan Cursors
cd ~/build
git clone https://github.com/vinceliuice/Layan-cursors
cd Layan-cursors
sudo ./install.sh

# Nordic Theme Install
cd ~/.themes/
git clone https://github.com/EliverLara/Nordic.git

```
