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
      ms-vscode-remote.remote-ssh
      github.copilot
      github.copilot-chat
      usernamehw.errorlens
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
      {
        name = "volar";
        publisher = "vue";
        version = "2.0.6";
        sha256 = "VbTroWemVVoBW/LwR4OueyIFPUKUuRE5e3QTONO1eZc=";
      }
      {
        name = "ayu";
        publisher = "teabyii";
        version = "1.0.5";
        sha256 = "+IFqgWliKr+qjBLmQlzF44XNbN7Br5a119v9WAnZOu4=";
      }
      {
        name = "auto-toggle-sidebar";
        publisher = "dominicvonk";
        version = "0.0.2";
        sha256 = "dIarW3cbC6mdL0Gmito7e2D32AszUvNFyG4WFOxyahw=";
      }
    ];

    keybindings = builtins.fromJSON (builtins.readFile ../../dotfiles/vscode/keybindings.json);
    userSettings = builtins.fromJSON (builtins.readFile ../../dotfiles/vscode/userSettings.json);
  };

}
