{ inputs
, outputs
, lib
, config
, pkgs
, ...
}:

{
  # You can import other home-manager modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
    ./apps/alacritty.nix
    ./apps/git.nix
    ./apps/zsh.nix
    ./apps/tmux.nix
    ./apps/vscode
    ./apps/direnv.nix
    ./apps/phpstorm.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
      outputs.overlays.devenv-unstable-packages
      outputs.overlays.vscode-unstable-packages
      outputs.overlays.nur

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;
  home.packages = with pkgs; [
    # Terminal
    tree
    neovim
    fzf
    zoxide # jump around directories
    eza # the new "ls" command
    # navi # take advantage of tldr and cheat.sh with powerful expansions: https://dev.to/kbknapp/using-navi-for-cli-cheats-945
    thefuck # when you misspelled commands, you can type "fuck" for autocorrection

    devenv-unstable.devenv # This made development easier and no needs to use docker for separate version control...

    # fonts
    (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" "FiraCode" "CascadiaCode" ]; })
  ];

  programs.home-manager.enable = true;

  # font settings
  fonts.fontconfig.enable = true;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.11";
}
