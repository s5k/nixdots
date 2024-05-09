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

# Kmonad as non-root user
sudo groupadd uinput
sudo usermod -aG input $USER
sudo usermod -aG uinput $USER

echo "KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"" | sudo tee /etc/udev/rules.d/99-uinput.rules
echo "KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"" | sudo tee /lib/udev/rules.d/99-uinput.rules

# Add zsh to /etc/shells
sudo sh -c "echo $(which zsh) >> /etc/shells"
sudo chsh -s $(which zsh) $USER

# install crontab
sudo pacman -S cronie -y
cat ~/Documents/nixdots/dotfiles/crontab/.cron | crontab -
