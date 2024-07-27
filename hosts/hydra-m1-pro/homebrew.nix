{ config, pkgs, ... }:

{
  environment.shellInit = ''
    eval "$(${config.homebrew.brewPrefix}/brew shellenv)"
  '';

  homebrew = {
    enable = true;
    onActivation.autoUpdate = true;
    onActivation.cleanup = "uninstall";
    global.brewfile = true;

    taps = [
      "homebrew/services"
      "nrlquaker/createzap"
    ];

    # If an app isn't available in the Mac App Store, or the version in the App Store has
    # limitiations, or Nixpkgs missing these packages, e.g., Transmit, Sequel Ace, install the Homebrew Cask.
    casks = [
      "sequel-ace"
      "postman"
    ];

    # Prefer installing application from the Mac App Store
    masApps = { };
  };
}
