{ pkgs, outputs, ... }:

{
  imports = [
    outputs.homeManagerModules.dconf-gnome
  ];

  home.packages = with pkgs; [
    # Remap keyboards
    # Read this FAQ to configure run Kmonad as non-root user: https://github.com/kmonad/kmonad/blob/master/doc/faq.md#q-how-do-i-get-uinput-permissions
    nur.repos.meain.kmonad
    gnomeExtensions.kmonad-toggle
  ];

  gtk = {
    enable = true;
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
  };
}
