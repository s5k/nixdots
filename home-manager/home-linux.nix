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
    ./apps/gnome.nix
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
    config = { };
  };

  # TODO: Set your username
  home = {
    username = "hydra";
    homeDirectory = "/home/hydra";
  };

  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;
  home.packages = with pkgs; [
    # Database gui
    dbeaver

    mongodb-compass
    postman

    # fonts
    appleEmoji

    # wrapper GPU acceleration for GUI apps
    (import ./apps/nixgl.nix { inherit inputs pkgs; }).package
  ];

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.11";

  # Enable XDG integration (for display apps on laucher)
  xdg.enable = true;
  xdg.mime.enable = true;
  targets.genericLinux.enable = true;
}
