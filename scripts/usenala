#!/bin/bash
username=$(id -u -n 1000)
# Configure bash to use nala wrapper instead of apt
usenala="/home/$username/.use-nala"
rusenala="/root/.use-nala"
ubashrc="/home/$username/.bashrc"
rbashrc="/root/.bashrc"
if [ ! -f "$usenala" ]; then
cat << \EOF > "$usenala"
apt() {
  command nala "$@"
}
sudo() {
  if [ "$1" = "apt" ]; then
    shift
    command sudo nala "$@"
  else
    command sudo "$@"
  fi
}
EOF
cat << EOF >> "$ubashrc"
if [ -f "$usenala" ]; then
        . "$usenala"
fi
EOF
fi

if [ ! -f "$rusenala" ]; then
cat << \EOF > "$rusenala"
apt() {
  command nala "$@"
}
EOF
cat << EOF >> "$rbashrc"
if [ -f "$rusenala" ]; then
        . "$rusenala"
fi
EOF
fi
