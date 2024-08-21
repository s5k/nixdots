{ pkgs, ... }:

{
  programs.git = {
    enable = true;
    userName = "s5k";
    userEmail = "40916972+s5k@users.noreply.github.com";
    aliases = {
      "co" = ''checkout'';
    };
    extraConfig = {
      url = {
        "ssh://git@github.com" = { insteadOf = [ "https://github.com" "gh" ]; };
      };
      url = { "ssh://git@gitlab.com" = { insteadOf = "https://gitlab.com"; }; };
      url = {
        "ssh://git@bitbucket.org" = { insteadOf = "https://bitbucket.org"; };
      };
      pull = { rebase = true; };
      init = { defaultBranch = "master"; };
      rebase = { abbreviateCommands = true; autoStash = true; };
      push = { default = "current"; autoSetupRemote = true; };
      pack = { threads = 0; };
      core = { pager = "${pkgs.delta}/bin/delta"; };
      interactive = { diffFilter = "${pkgs.delta}/bin/delta --color-only"; };
      delta = {
        navigate = true;
        features = "side-by-side line-numbers decorations";
      };
    };
  };
}
