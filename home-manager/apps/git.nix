{ pkgs, self, ... }:

{
  programs.git = {
    enable = true;
    userName = "s5k";
    userEmail = "40916972+s5k@users.noreply.github.com";
    aliases = {
      "co" = ''checkout'';
    };
    extraConfig = {
      init = {
        defaultBranch = "main";
      };
      url = {
        "ssh://git@github.com" = { insteadOf = [ "https://github.com" "gh" ]; };
        "ssh://git@gitlab.com" = { insteadOf = "https://gitlab.com"; };
        "ssh://git@bitbucket.org" = { insteadOf = "https://bitbucket.org"; };
      };
      pull = { rebase = true; };
      rebase = { abbreviateCommands = true; autoStash = true; };
      push = { default = "current"; autoSetupRemote = true; };
      pack = { threads = 0; };
      rerere = {
        enabled = true;
      };
      core = {
        pager = "${pkgs.delta}/bin/delta";
        excludesfile = "${self.outPath}/dotfiles/git/.gitignore.global";
      };
      interactive = { diffFilter = "${pkgs.delta}/bin/delta --color-only"; };
      delta = {
        navigate = true;
        features = "side-by-side line-numbers decorations";
      };
    };
  };
}
