{ pkgs
, ...
}:

{
  imports = [
    ./remote-ssh-patch
  ];

  services.vscode-server.enable = true;

  home.packages = with pkgs; [
    nixpkgs-fmt
  ];

  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
    enableExtensionUpdateCheck = false;
    enableUpdateCheck = false;
    mutableExtensionsDir = false;

    extensions = with pkgs.vscode-unstable.vscode-extensions; [
      ms-vscode-remote.remote-ssh
      github.copilot
      github.copilot-chat

      usernamehw.errorlens
      vscodevim.vim
      bmewburn.vscode-intelephense-client
      bbenoist.nix
      b4dm4n.vscode-nixpkgs-fmt
      eamodio.gitlens
      esbenp.prettier-vscode # temporary use Prettier for formatting when collaborating with others

      ritwickdey.liveserver
      rust-lang.rust-analyzer
      svsool.markdown-memo
      bierner.markdown-mermaid

      yoavbls.pretty-ts-errors
      biomejs.biome
      teabyii.ayu
    ] ++ pkgs.vscode-unstable.vscode-utils.extensionsFromVscodeMarketplace [
      ### install extensions from marketplace when nixpkgs is not built
      {
        name = "roo-cline";
        publisher = "RooVeterinaryInc";
        version = "3.24.0";
        sha256 = "+f/F6GZ+h3oF26evKRxYpBqnuaNm2v5waKwMzQJpo/g=";
      }
      {
        name = "vscode-edit-csv";
        publisher = "janisdd";
        version = "0.9.2";
        sha256 = "F/YEMrRlkLdIOATq+u6ovdZt21MgVbYH1PAnpyncFqs=";
      }
      {
        name = "volar";
        publisher = "vue";
        version = "2.0.6";
        sha256 = "VbTroWemVVoBW/LwR4OueyIFPUKUuRE5e3QTONO1eZc=";
      }
      {
        name = "auto-toggle-sidebar";
        publisher = "dominicvonk";
        version = "0.0.2";
        sha256 = "dIarW3cbC6mdL0Gmito7e2D32AszUvNFyG4WFOxyahw=";
      }
      {
        name = "symbols";
        publisher = "miguelsolorio";
        version = "0.0.24";
        sha256 = "yEE6G2e/a2/DcKq1+Vtv0YIAtWZG5LyXfZ6cbheRV1g=";
      }
    ];

    keybindings =
      if pkgs.stdenv.isLinux
      then builtins.fromJSON (builtins.readFile ../../../dotfiles/vscode/keybinding-linux.json)
      else builtins.fromJSON (builtins.readFile ../../../dotfiles/vscode/keybinding-macos.json);
    userSettings = builtins.fromJSON (builtins.readFile ../../../dotfiles/vscode/userSettings.json);
  };

}
