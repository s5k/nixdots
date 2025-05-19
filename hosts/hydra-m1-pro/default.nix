{ config
, pkgs
, lib
, home-manager
, ...
}:
{
  imports = [
    ./hotkeys.nix
    ./homebrew.nix
  ];

  users.users.Hydra = {
    description = "Hydra's M1 Pro";
    home = "/Users/hydra";
  };

  programs.zsh.enable = true; # Weird bug with zsh installed from HM, didn't patch bin path of darwin-rebuild, so this line is needed.
  ids.uids.nixbld = 300;

  networking.knownNetworkServices = [ "Wi-Fi" "Bluetooth PAN" "Thunderbolt Bridge" ];
  networking.dns = [ "1.1.1.1" "1.0.0.1" "2606:4700:4700::1111" "2606:4700:4700::1001" ];

  # Add ability to used TouchID for sudo authentication
  # security.pam.enableSudoTouchIdAuth = true;
  security.pam.services.sudo_local.touchIdAuth = true;

  # Store management
  nix.gc.automatic = true;
  nix.gc.interval.Hour = 3;
  nix.gc.options = "--delete-older-than 15d";
  nix.optimise.automatic = true;
  nix.optimise.interval.Hour = 4;

  # Enable experimental features
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  # Allow hydra user for trusted users
  nix.settings.trusted-users = [ "root" "hydra" ];

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system = {
    stateVersion = 4;

    defaults = {
      LaunchServices.LSQuarantine = false; # Disable Quarantine for Downloaded Applications
      SoftwareUpdate.AutomaticallyInstallMacOSUpdates = false;

      loginwindow = {
        GuestEnabled = false;
      };

      # Dock
      dock = {
        tilesize = 22;
        show-recents = false;
      };

      # Trackpad
      trackpad = {
        Clicking = true;
      };

      NSGlobalDomain = {
        "com.apple.trackpad.scaling" = 3.0;
      };
      ".GlobalPreferences" = {
        "com.apple.mouse.scaling" = 3.0;
      };

      # Save screenshots to ~/Pictures/Screenshots
      screencapture.location = "~/Pictures/Screenshots";
    };
  };
}

