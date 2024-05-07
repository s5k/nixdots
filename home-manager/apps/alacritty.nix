{ inputs, pkgs, ... }:

let
  # TEMPORARY: use nixGL to run GUI programs.
  nixGLWrap = (import ./nixgl.nix { inherit inputs pkgs; }).nixGLWrap;
in
{
  home.file.".config/alacritty/alacritty.toml".source = ../../dotfiles/alacritty/alacritty.toml;

  programs.alacritty = {
    enable = true;
    package = if pkgs.stdenv.isLinux then (nixGLWrap pkgs.unstable.alacritty) else pkgs.unstable.alacritty;
  };
}
