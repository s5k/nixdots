{ config, pkgs, ... }:

{
  environment.shellInit = ''
    eval "$(${config.homebrew.brewPrefix}/brew shellenv)"
  '';

  homebrew = {
    enable = true;
    onActivation.autoUpdate = true;
    onActivation.cleanup = "zap";
    global.brewfile = true;

    taps = [
      "homebrew/services"
      "nrlquaker/createzap" # The "zap" command is available in cask and is very useful to perform system cleaning at the same time as the uninstall
    ];

    # If an app isn't available in the Mac App Store, or the version in the App Store has
    # limitiations, or Nixpkgs missing these packages, e.g., Transmit, Sequel Ace, install the Homebrew Cask.
    casks = [
      "swiftbar"
      "sequel-ace"
      "dbeaver-community"
      "postman"
      "phpstorm"
      "cyberduck"
      "onlyoffice"
      "cursor"
      "orbstack"
      "anydesk"
      "obsidian"
    ];

    brews = [
      "qcachegrind"
    ];

    # Prefer installing application from the Mac App Store
    masApps = { };
  };
}
