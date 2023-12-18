{ lib, stdenvNoCC, fetchurl  }:

stdenvNoCC.mkDerivation {
  name = "AppleEmojiForLinux";
  dontConfigue = true;

  src = fetchurl {
    url = "https://github.com/samuelngs/apple-emoji-linux/releases/latest/download/AppleColorEmoji.ttf";
    sha256 = "sha256-1e1Xz7wF1NhCe0zUdJWXE6hPGmkylAeggsN01T3WWpU=";
  };

  phases = [ "installPhase" ]; # Removes all phases except installPhase

  installPhase = ''
    mkdir -p $out/share/fonts
    cp -R $src $out/share/fonts/
    '';

  meta =  {
    description = "Apple Color Emoji for Linux";
    homepage = "https://github.com/samuelngs/apple-emoji-linux";
  };

}
