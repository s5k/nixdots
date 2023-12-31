#! /bin/bash

# Xclip for tmux-yank
sudo pacman -S xclip

# Microsoft EDGE
yay -S microsoft-edge-stable

# Vietnamese IME (IBus service)
bash -c "$(curl -fsSL https://raw.githubusercontent.com/BambooEngine/ibus-bamboo/master/archlinux/install.sh)"

# Docker
sudo pacman -S docker docker-compose
sudo systemctl enable docker.service

# Kmonad as non-root user
sudo groupadd uinput
sudo usermod -aG input $USER
sudo usermod -aG uinput $USER

echo "KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"" | sudo tee /etc/udev/rules.d/99-uinput.rules
echo "KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"" | sudo tee /lib/udev/rules.d/99-uinput.rules

# Add zsh to /etc/shells
sudo sh -c "echo $(which zsh) >> /etc/shells"
sudo chsh -s $(which zsh) $USER
