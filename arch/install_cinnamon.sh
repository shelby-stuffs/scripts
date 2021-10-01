#!/usr/bin/env bash

# Install all packages required for cinnamon to work nicely
yay -Sy xorg-server cinnamon gnome-terminal-transparency gnome-screenshot lightdm lightdm-slick-greeter nemo-fileroller gnome-keyring pipewire pipewire-pulse papirus-icon-theme arc-gtk-theme
sudo localectl set-locale LANG=en_US.UTF-8
sudo locale-gen

# Setup lightdm along with slick-greeter plus necessary configs
sudo sed -i "s/#greeter-session=example-gtk-gnome/greeter-session=lightdm-slick-greeter/" /etc/lightdm/lightdm.conf

# Install packages related to bluetooth if needed
read -e -p "Do you have any bluetooth adaptors installed? [y/n]: " input
if [[ "$input" =~ ^[Yy]$ ]]; then
sudo pacman -Sy bluez bluez-utils blueman
sudo systemctl enable bluetooth.service
fi

# Enable some services for convenience
sudo systemctl enable lightdm.service
sudo systemctl enable NetworkManager.service
sudo systemctl disable NetworkManager-wait-online.service
