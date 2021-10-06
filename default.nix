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

  appimageEntrypoint = pkgs.writeScript "mediocre-loadout" ''
    #!${pkgs.bash}/bin/bash

    cmd="$1"; shift;

    if [ "$cmd" = "nvim" ]; then exec nvim "$@"; fi
    if [ "$cmd" = "zsh" ]; then exec zsh "$@"; fi
    if [ "$cmd" = "alacritty" ]; then exec alacritty "$@"; fi
    if [ "$cmd" = "awesome" ]; then exec awesome "$@"; fi

    echo "USAGE: $0 [nvim|zsh|alacritty|awesome] [passthrough args...]"
    exit 1
  '';

  appimageDesktopFile = builtins.toFile "mediocre-loadout.desktop" ''
    [Desktop Entry]
    Name=Mediocre Loadout
    Exec=mediocre-loadout alacritty
    Icon=mediocre-loadout
    Type=Application
    Categories=Utility;
  '';

  appdir = pkgs.stdenv.mkDerivation {
    name = "mediocre-loadout-target-flat";

    inherit appimageEntrypoint appimageDesktopFile;
    appimageIcon = ./bonzi.png;
    src = loadout;

    builder = builtins.toFile "builder.sh" ''
      source $stdenv/setup

      cp -rL "$src" "$out"
      chmod -R +w "$out"

      rm -rf "$out"/share/applications/*
      cp "$appimageDesktopFile" "$out"/share/applications/mediocre-loadout.desktop
      cp "$appimageEntrypoint" "$out"/bin/mediocre-loadout

      icondir=share/icons/hicolor/256x256/apps
      mkdir -p "$out"/$icondir
      cp "$appimageIcon" "$out"/$icondir/mediocre-loadout.png
    '';
  };

  appimage = ((import ./appimage.nix) { pkgsSrc = pkgsSrc; }) {
    name = "mediocre-loadout";
    target = appdir;
  };

}
