#!/bin/bash

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
