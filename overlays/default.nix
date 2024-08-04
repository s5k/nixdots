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

    # Workaround for install APC extension on MacOS
    vscode = prev.unstable.vscode.overrideAttrs (old:
      {
        vscodeWithExtensions = prev.vscode-utils.extensionsFromVscodeMarketplace [
          {
            name = "apc-extension";
            publisher = "drcika";
            version = "0.3.9";
            sha256 = "sha256-VMUICGvAFWrG/uL3aGKNUIt1ARovc84TxkjgSkXuoME=";
          }
        ];

        postPatch = old.postPatch or "" + ''
          cp "${./patch-vscode.sh}" $TMPDIR/patch-vscode.sh
          chmod +x $TMPDIR/patch-vscode.sh
          cp -r "$vscodeWithExtensions/share/vscode/extensions/drcika.apc-extension/." "$TMPDIR/extension/"
          $TMPDIR/patch-vscode.sh "$TMPDIR/extension" "Contents/Resources/app/out"
          touch Contents/Resources/app/out/bootstrap-amd.js.apc.extension.backup
        '';
      });
  };

  # When applied, the unstable nixpkgs set (declared in the flake inputs) will
  # be accessible through 'pkgs.unstable'
  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = final.system;
      config.allowUnfree = true;
    };
  };
}
