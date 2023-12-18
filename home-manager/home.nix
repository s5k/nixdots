{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: 
let
  #TEMPORARY: use nixGL to run GUI programs.
  nixGLWrap = pkg: pkgs.runCommand "${pkg.name}-nixgl-wrapper" {} ''
    mkdir $out
    ln -s ${pkg}/* $out
    rm $out/bin
    mkdir $out/bin
    for bin in ${pkg}/bin/*; do
     wrapped_bin=$out/bin/$(basename $bin)
     echo "exec nixGLIntel $bin \$@" > $wrapped_bin
     chmod +x $wrapped_bin
    done
  '';
in
{
  # You can import other home-manager modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages

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

  # TODO: Set your username
  home = {
    username = "hydra";
    homeDirectory = "/home/hydra";
  };

  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;
  home.packages = with pkgs; [
	neovim 

	# terminal
	zoxide
	exa

	# fonts
	appleEmoji
	(pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; })

	(nixGLWrap alacritty)
	(import inputs.nixGL { inherit pkgs; }).nixGLIntel
  ];

  home.file = {
  	".config/alacritty/alacritty.yml".source = ../dotfiles/alacritty/alacritty.yml;
  };

  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.git.enable = true;
  programs.zsh = {
  	enable = true;
	enableSyntaxHighlighting = true;
	enableAutosuggestions = true;
	oh-my-zsh = {
	  enable = true;
          theme = "robbyrussell";
          plugins = [
            "sudo"
            "terraform"
            "systemadmin"
            "vi-mode"
            "fzf"
	    "git"
          ];
	};
	initExtra = "
if [ -f $HOME/Documents/nix-config/dotfiles/zsh/.zshrc ];
then
  source $HOME/Documents/nix-config/dotfiles/zsh/.zshrc
fi
";
  };

  # font settings
  fonts.fontconfig.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";

  # Enable XDG integration
  xdg.enable = true;
  xdg.mime.enable = true;
  targets.genericLinux.enable = true;
}
