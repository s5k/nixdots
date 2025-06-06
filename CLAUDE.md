# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Common Commands

### Building and Deploying Configurations
- `darwin-rebuild switch --flake .#Hydra-M1-Pro` - Apply nix-darwin system configuration for macOS
- `home-manager switch --flake .#hydra@macos` - Apply home-manager configuration for macOS user
- `home-manager switch --flake .#hydra@hydra-arch2` - Apply home-manager configuration for Linux user
- `nix fmt` - Format Nix files using alejandra formatter

### Development
- `nix develop` - Enter development shell if devenv is configured in a project subdirectory
- `nix build` - Build custom packages defined in pkgs/
- `nix flake check` - Validate flake configuration

## Architecture Overview

This is a Nix flake-based dotfiles configuration that manages both system-level (nix-darwin) and user-level (home-manager) configurations across macOS and Linux.

### Key Structure
- **flake.nix**: Main entry point defining inputs, outputs, and system configurations
- **hosts/**: System-level configurations (nix-darwin for macOS)
  - `hydra-m1-pro/`: macOS system configuration including homebrew, hotkeys, and system preferences
- **home-manager/**: User-level configurations
  - `home-common.nix`: Shared configuration across all platforms
  - `home-darwin.nix`: macOS-specific user configuration
  - `home-linux.nix`: Linux-specific user configuration
  - `apps/`: Individual application configurations (alacritty, git, zsh, tmux, vscode, etc.)
- **dotfiles/**: Raw configuration files for applications (referenced by Nix configurations)
- **modules/**: Custom Nix modules for reusable functionality
- **overlays/**: Package modifications and additions
- **pkgs/**: Custom package definitions

### Configuration Philosophy
- Uses multiple nixpkgs versions (23.11 stable, 24.05, unstable) for different purposes
- Separates platform-specific configurations while sharing common base
- Applications are configured both through Nix modules and traditional dotfiles
- Keyboard customization is handled through Kanata configurations in dotfiles/kanata/

### Application Management
- System packages via homebrew.nix (macOS) or native package managers
- User packages via home-manager with Nix
- Development environments via devenv for project-specific tooling
- VSCode extensions and settings managed through Nix with custom patches

When modifying configurations, ensure changes are made to the appropriate Nix files rather than directly editing generated dotfiles.