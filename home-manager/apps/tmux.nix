{ pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    keyMode = "vi";
    extraConfig = builtins.readFile ../../dotfiles/tmux/tmux.conf;

    plugins = with pkgs; [
      tmuxPlugins.sensible
      tmuxPlugins.yank
      tmuxPlugins.prefix-highlight
    ];
  };
}
