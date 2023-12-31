#! /bin/bash

# Xclip for tmux-yank
sudo pacman xclip

# Microsoft EDGE
yay -S microsoft-edge-stable

# Vietnamese IME (IBus service)
bash -c "$(curl -fsSL https://raw.githubusercontent.com/BambooEngine/ibus-bamboo/master/archlinux/install.sh)"
