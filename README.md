The boilerplate template for setting up Nix’s configuration was credited to **[Misterio77’s nix-starter-configs](https://github.com/Misterio77/nix-starter-configs)**.

## Prerequisites

- [Nix, Home-manager](https://nixos.org/)
- [Nix-darwin](https://github.com/LnL7/nix-darwin)
- [Homebrew with Nix-darwin](https://davi.sh/blog/2024/01/nix-darwin/)
- [Kanata](https://github.com/jtroo/kanata) (Improve keyboard comfort and usability with advanced customization)
- [Warpd](https://github.com/rvaiya/warpd) (A modal keyboard-driven virtual pointer)

## Install and usage

Basically, you can clone this repository to your Documents directory, e.g: <code>~/Documents/nixdots</code>, then jump into the folder and run these commands:

```
darwin-rebuild switch --flake .#Hydra-M1-Pro
home-manager switch --flake .#hydra@macos
```
