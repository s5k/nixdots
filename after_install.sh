#! /bin/bash

# Xclip for tmux-yank
sudo pacman -S xclip -y

# Microsoft EDGE
yay -S microsoft-edge-stable -y

# Vietnamese IME (IBus service)
bash -c "$(curl -fsSL https://raw.githubusercontent.com/BambooEngine/ibus-bamboo/master/archlinux/install.sh)"

# Docker
sudo pacman -S docker docker-compose -y
sudo systemctl enable docker.service
sudo chmod 666 /var/run/docker.sock

# Add zsh to /etc/shells
sudo sh -c "echo $(which zsh) >> /etc/shells"
sudo chsh -s $(which zsh) $USER
