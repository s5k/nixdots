# refer to this link to set zsh as default shell: https://discourse.nixos.org/t/unable-to-set-or-use-zsh-shell-from-standalone-home-manager-using-flakes/29269/3
# 1. add path zsh to /etc/shells (find zsh path: which zsh)
# 2. run command chsh to set the zsh path
# 3. logout and login again

{ pkgs, lib, config, self, ... }:

{
  programs.starship = {
    enable = true;
  };

  home.file.".config/starship.toml".source = ../../dotfiles/starship/starship.toml;

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    plugins = [
      {
        name = "vi-mode";
        src = pkgs.zsh-vi-mode;
        file = "share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
      }
      {
        name = "zsh-fast-syntax-highlighting";
        src = pkgs.zsh-fast-syntax-highlighting;
        file = "share/zsh/site-functions/fast-syntax-highlighting.plugin.zsh";
      }
      {
        name = "fzf-tab";
        src = pkgs.zsh-fzf-tab;
        file = "share/fzf-tab/fzf-tab.plugin.zsh";
      }
    ];
    initExtraFirst = ''
      ZVM_INIT_MODE=sourcing
    '';
    initExtra = ''
      if [ -f ${self.outPath}/dotfiles/zsh/.zshrc ];
      then
        source ${self.outPath}/dotfiles/zsh/.zshrc
      fi
    '';
  };

  programs.navi = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      cheats = {
        paths = [
          "${self.outPath}/dotfiles/navi/cheats"
          "$HOME/Library/Application Support/navi/cheats"
          "$HOME/.local/share/navi/cheats"
        ];
      };
    };
  };
}
