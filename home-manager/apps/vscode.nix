{ pkgs, ... }:

{
  home.packages = with pkgs; [
    nixpkgs-fmt
  ];

  programs.vscode = {
    enable = true;
    package = pkgs.unstable.vscode;
    enableExtensionUpdateCheck = false;
    enableUpdateCheck = false;
    mutableExtensionsDir = false;

    extensions = with pkgs.vscode-extensions; [
      github.copilot
      github.copilot-chat
      usernamehw.errorlens
      github.github-vscode-theme
      vscodevim.vim
      esbenp.prettier-vscode
      dbaeumer.vscode-eslint
      bmewburn.vscode-intelephense-client
      bbenoist.nix
      b4dm4n.vscode-nixpkgs-fmt
    ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      ### install extensions from marketplace when nixpkgs is not built
      # {
      #   name = "copilot-chat";
      #   publisher = "github";
      #   version = "0.12.2023122001";
      #   sha256 = "LsDcdlw+TdkCeHxpvY9qjAWEFjl9OXU7RNV9VLVFSdg=";
      # }
    ];

    keybindings = builtins.fromJSON (builtins.readFile ../../dotfiles/vscode/keybindings.json);
    userSettings = builtins.fromJSON (builtins.readFile ../../dotfiles/vscode/userSettings.json);
  };

}
