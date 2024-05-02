{ pkgs, ... }:

{
  home.packages = with pkgs; [
    nixpkgs-fmt
  ];

  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
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
      ms-vscode-remote.remote-ssh
      ritwickdey.liveserver
      eamodio.gitlens
    ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      ### install extensions from marketplace when nixpkgs is not built
      {
        name = "prophet";
        publisher = "sqrtt";
        version = "1.4.40";
        sha256 = "hhpLKnd9U2gxs9saiUBdlR+eJh2PPeIxTi9kK7CgH20=";
      }
    ];

    keybindings = builtins.fromJSON (builtins.readFile ../../dotfiles/vscode/keybindings.json);
    userSettings = builtins.fromJSON (builtins.readFile ../../dotfiles/vscode/userSettings.json);
  };

}
