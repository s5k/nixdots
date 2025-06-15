# This file defines overlays
{ inputs
, ...
}: {
  nur = inputs.nur.overlay;

  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev: import ../pkgs { pkgs = final; };

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = final: prev: {
    # example = prev.example.overrideAttrs (oldAttrs: rec {
    # ...
    # });
    # TEMPORARY: self upgrade postman for Linux
    postman = prev.postman.overrideAttrs (old:
      let
        version = "10.21.0";
      in
      {
        inherit version;
        src = prev.fetchurl {
          url = "https://dl.pstmn.io/download/version/${version}/linux64";
          name = "${old.pname}-${version}.tar.gz";
          sha256 = "SCaNZli29M+qEXYku8zwCob6EAdtg6eVl19opSWqypE=";
        };
      }
    );

    # VSCode with custom CSS/JS injection support
    vscode = (import ./vscode.nix) { inherit prev; };
  };

  # When applied, the unstable nixpkgs set (declared in the flake inputs) will
  # be accessible through 'pkgs.unstable'
  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = final.system;
      config.allowUnfree = true;
    };
  };

  devenv-unstable-packages = final: _prev: {
    devenv-unstable = import inputs.nixpkgs-devenv-unstable {
      system = final.system;
      config.allowUnfree = true;
    };
  };

  vscode-unstable-packages = final: _prev: {
    vscode-unstable = import inputs.nixpkgs-vscode-unstable {
      system = final.system;
      config.allowUnfree = true;
    };
  };
}
