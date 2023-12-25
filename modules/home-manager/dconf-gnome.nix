{ config, lib, pkgs, sources, ... }:

with lib;
let
  iniFile = ../../dotfiles/gnome/extension-settings.dconf;
in
{
  home.activation.dconf = hm.dag.entryAfter [ "installPackages" ]
    ''
      /usr/bin/dconf load /org/gnome/shell/extensions/ < ${iniFile} || echo "Loading dconf failed"
    '';
}
