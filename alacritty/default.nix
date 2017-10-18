{

  pkgs ? (import ../pkgs.nix) {},
  zsh ? pkgs.zsh,

}: rec {

  # TODO figure out a way to provide my font to alacritty at runtime. fontconfig
  # is a hot mess...
  #
  #dataDir = pkgs.stdenv.mkDerivation {
  #  name = "alacritty-dataDir";
  #  src = ./fonts;
  #  buildInputs = [ pkgs.fontconfig ];
  #  builder = builtins.toFile "builder.sh" ''
  #    source $stdenv/setup
  #    mkdir "$out"
  #    cp -r "$src" "$out"/fonts
  #    chmod -R +w "$out"

  #    env

  #    export FONTCONFIG_FILE="$out"/fontconfig
  #    fc-cache --verbose "$out"/fonts

  #  '';
  #};

  alacritty = pkgs.writeScriptBin "alacritty" ''
    #!${pkgs.bash}/bin/bash
    exec ${pkgs.nixgl}/bin/nixGLIntel ${pkgs.alacritty}/bin/alacritty \
      --config-file ${./alacritty.yml} \
      -e "${zsh}/bin/zsh"
  '';
}
