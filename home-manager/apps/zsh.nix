# refer to this link to set zsh as default shell: https://discourse.nixos.org/t/unable-to-set-or-use-zsh-shell-from-standalone-home-manager-using-flakes/29269/3
# 1. add path zsh to /etc/shells (find zsh path: which zsh)
# 2. run command chsh to set the zsh path
# 3. logout and login again

{
  programs.zsh = {
    enable = true;
    syntaxHighlighting.enable = true;
    enableAutosuggestions = true;
    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [
        "sudo"
        "vi-mode"
        "fzf"
        "git"
      ];
    };
    initExtra = "
      if [ -f $HOME/Documents/nixdots/dotfiles/zsh/.zshrc ];
      then
        source $HOME/Documents/nixdots/dotfiles/zsh/.zshrc
      fi
      ";
  };
}
