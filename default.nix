{

  pkgsSrc ? ./pkgs.nix

}: rec {

  pkgs = (import pkgsSrc) {};

  gitConfig = pkgs.writeTextDir "git/config"
    (builtins.readFile ./base/gitconfig);

  git = pkgs.writeScriptBin "git" ''
    #!${pkgs.bash}/bin/bash
    export XDG_CONFIG_HOME=${gitConfig}
    exec ${pkgs.git}/bin/git "$@"
  '';

  zsh = ((import ./zsh) { inherit pkgs; }).zsh;

  loadout = pkgs.buildEnv {
    name = "loadout";
    paths = [

      pkgs.gnugrep
      pkgs.ag
      pkgs.gawk

      git
      pkgs.mercurial
      pkgs.breezy # bzr

      pkgs.gcc
      pkgs.gnumake
      pkgs.cmake
      pkgs.strace

      pkgs.curl
      pkgs.wget
      pkgs.rsync

      pkgs.hostname
      pkgs.netcat
      pkgs.nmap
      pkgs.dnsutils
      pkgs.openssh

      pkgs.tmux

      pkgs.ncdu
      pkgs.htop

      pkgs.unzip
      pkgs.unrar
      pkgs.gzip

      pkgs.jq
      pkgs.yq
      pkgs.go

      pkgs.xsel
      pkgs.pavucontrol

      (pkgs.nerdfonts.override { fonts = [ "SourceCodePro" ]; })

      ((import ./nvim) { inherit pkgs; }).nvim
      zsh
      ((import ./alacritty) { inherit pkgs zsh; }).alacritty
      ((import ./awesome) { inherit pkgs; }).awesome
    ];
  };

  appimageEntrypoint = pkgs.writeScriptBin "mediocre-loadout" ''
    #!${pkgs.bash}/bin/bash

    cmd="$1"; shift;

    if [ "$cmd" = "editor" ]; then exec nvim "$@"; fi
    if [ "$cmd" = "shell" ]; then exec zsh "$@"; fi
    if [ "$cmd" = "gui" ]; then exec alacritty "$@"; fi
    if [ "$cmd" = "wm" ]; then exec awesome "$@"; fi

    echo "USAGE: $0 [editor|shell|gui|wm] [passthrough args...]"
    exit 1
  '';

  appimageIcon = pkgs.stdenv.mkDerivation {
    name = "mediocre-loadout-icon";
    src = ./bonzi.png;
    builder = builtins.toFile "builder.sh" ''
      source $stdenv/setup
      dir=share/icons/hicolor/256x256/apps
      mkdir -p "$out"/$dir
      cp $src "$out"/$dir/mediocre-loadout.png
    '';
  };

  appimageDesktopFile = pkgs.writeTextDir "share/applications/mediocre-loadout.desktop" ''
    [Desktop Entry]
    Name=Mediocre Loadout
    Exec=mediocre-loadout gui
    Icon=mediocre-loadout
    Type=Application
    Categories=Utility;
  '';

  appimageTarget = pkgs.buildEnv {
    name = "mediocre-loadout-target";
    paths = [
      loadout
      appimageEntrypoint
      appimageIcon
      appimageDesktopFile
    ];
  };

  appimageTargetFlat = pkgs.stdenv.mkDerivation {
    name = "mediocre-loadout-target-flat";
    src = appimageTarget;
    builder = builtins.toFile "builder.sh" ''
      source $stdenv/setup
      cp -rL "$src" "$out"
    '';
  };

  appimage = ((import ./appimage.nix) { pkgsSrc = pkgsSrc; }) {
    name = "mediocre-loadout";
    target = appimageTargetFlat;
  };

}
