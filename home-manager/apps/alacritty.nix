{ inputs, pkgs, ... }:

let
    # TEMPORARY: use nixGL to run GUI programs.
    nixGLWrap = (import ./nixgl.nix { inherit inputs pkgs; }).nixGLWrap;
in
{
    home.file.".config/alacritty/alacritty.yml".source = ../../dotfiles/alacritty/alacritty.yml;

    programs.alacritty = {
        enable = true;
        package = if pkgs.stdenv.isLinux then (nixGLWrap pkgs.alacritty) else pkgs.alacritty;
    };
}