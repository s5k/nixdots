{ pkgs, ... }:

{
  home.packages = with pkgs; [
    nixpkgs-fmt
  ];

  programs.vscode = {
    enable = true;
    enableExtensionUpdateCheck = false;
    enableUpdateCheck = false;
    mutableExtensionsDir = false;

    extensions = with pkgs.vscode-extensions; [
      github.copilot
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
      #{
      #    name = "erlang-ls";
      #    publisher = "erlang-ls";
      #    version = "0.0.40";
      #    sha256 = "HFlOig5UUsT+XX0h1dcRQ3mWRsASqvKTMpqqRhVpTAY=";
      #}
    ];

    keybindings = builtins.fromJSON (builtins.readFile ../../dotfiles/vscode/keybindings.json);
    userSettings = builtins.fromJSON (builtins.readFile ../../dotfiles/vscode/userSettings.json);
  };

}
