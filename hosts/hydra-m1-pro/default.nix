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

  # System packages
  environment.systemPackages = with pkgs; [
    # spoofdpi
    # xray
  ];

  # Launch as startup services
  launchd.user.agents = {

    # SpoofDPI is a tool to spoof DPI (Deep Packet Inspection) on macOS, useful for bypassing network restrictions.
    # spoofdpi = {
    #   serviceConfig = {
    #     ProgramArguments = [
    #       "${pkgs.spoofdpi}/bin/spoofdpi"
    #       "-dns-addr"
    #       "1.1.1.1"
    #       "-enable-doh"
    #     ];
    #     KeepAlive = true;
    #     RunAtLoad = true;
    #     StandardErrorPath = "/tmp/spoofdpi.log";
    #     StandardOutPath = "/tmp/spoofdpi.log";
    #   };
    # };

    # Xray is a platform for building proxies to bypass network restrictions
    # xray = {
    #   serviceConfig = {
    #     ProgramArguments = [
    #       "${pkgs.xray}/bin/xray"
    #       "run"
    #       "-config"
    #       "/etc/xray/config.json"
    #     ];
    #     KeepAlive = true;
    #     RunAtLoad = true;
    #     StandardErrorPath = "/tmp/xray.log";
    #     StandardOutPath = "/tmp/xray.log";
    #   };
    # };
  };

  # Create xray configuration directory and file
  # environment.etc."xray/config.json".text = builtins.toJSON {
  #   log = {
  #     loglevel = "warning";
  #   };

  #   dns = {
  #     servers = [
  #       "https://1.1.1.1/dns-query"
  #       "https://dns.google/dns-query"
  #     ];
  #   };

  #   inbounds = [
  #     {
  #       port = 1080;
  #       protocol = "socks";
  #       settings = {
  #         auth = "noauth";
  #       };
  #     }
  #   ];

  #   outbounds = [
  #     {
  #       protocol = "vless";
  #       settings = {
  #         "vnext" = [
  #           {
  #             "address" = "kaliwe.ru";
  #             "port" = 443;
  #             "users" = [
  #               {
  #                 "id" = "fcbedce3-a331-4bd6-9f96-45113c30a844";
  #                 "encryption" = "none";
  #               }
  #             ];
  #           }
  #         ];
  #       };
  #       streamSettings = {
  #         network = "h2";
  #         security = "tls";
  #         httpSettings = {
  #           host = [ "kaliwe.ru" ];
  #           path = "/posts";
  #         };
  #       };
  #     }
  #     # {
  #     #   protocol = "freedom";
  #     #   tag = "direct";
  #     #   settings = {
  #     #     # domainStrategy = "UseIPv4";
  #     #     domainStrategy = "UseIP";
  #     #     # redirect = "127.0.0.1:3366";
  #     #     # userLevel = 0;

  #     #     fragment = {
  #     #       packets = "tlshello";
  #     #       length = "100-200";
  #     #       interval = "10-20"; # in ms
  #     #     };

  #     #     noises = [
  #     #       {
  #     #         type = "base64";
  #     #         packet = "7nQBAAABAAAAAAAABnQtcmluZwZtc2VkZ2UDbmV0AAABAAE=";
  #     #         delay = "10-16";
  #     #       }
  #     #       {
  #     #         type = "rand";
  #     #         packet = "10-20";
  #     #         delay = "10-16";
  #     #       }
  #     #       {
  #     #         type = "str";
  #     #         packet = "hiGFW";
  #     #         delay = "10-16";
  #     #       }
  #     #     ];

  #     #     proxyProtocol = 0;
  #     #   };
  #     # }
  #   ];
  # };

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

