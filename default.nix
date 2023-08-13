{

  hostConfig,

  pkgs ? (import ./pkgs.nix).stable {},
  pkgs2305 ? (import ./pkgs.nix).stable2305 {},

}: let

  config = (import ./config/default.nix) // hostConfig ;

in rec {

  gitConfig = pkgs.stdenv.mkDerivation {
    name = "mediocregopher-git-config";

    gitConfigBase = ./base/gitconfig;
    gitConfigCustom = builtins.toFile "mediocregopher-git-config-custom"
      (pkgs.lib.generators.toGitINI config.git);

    builder = builtins.toFile "builder.sh" ''
      source $stdenv/setup

      dir="$out"/git
      mkdir -p "$dir"

      cp "$gitConfigBase" "$dir"/config
      cp "$gitConfigCustom" "$dir"/custom
    '';

  };

  git = pkgs.writeScriptBin "git" ''
    #!${pkgs.bash}/bin/bash
    export XDG_CONFIG_HOME=${gitConfig}
    exec ${pkgs.git}/bin/git "$@"
  '';

  zsh = ((import ./zsh) { inherit config; }).zsh;

  loadout = pkgs.buildEnv {
    name = "loadout";
    paths = [
      pkgs2305.nix

      pkgs.gnugrep
      pkgs.ag
      pkgs.gawk
      pkgs.tree

      git
      pkgs.mercurial
      pkgs.breezy # bzr

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
      pkgs.sshfs
      pkgs.fuse3

      pkgs.tmux

      pkgs.ncdu
      pkgs.htop
      pkgs.jnettop

      pkgs.unzip
      pkgs.unrar
      pkgs.gzip

      pkgs.jq
      pkgs.yq

      pkgs.tomb
      pkgs.udiskie

      ((import ./nvim) {}).nvim
      zsh
      ((import ./alacritty) { inherit config zsh; }).alacritty
      ((import ./awesome) { inherit config; }).awesome
    ];
  };

  fonts = pkgs.buildEnv {
    name = "fonts";
    paths = [
      pkgs.nerdfonts
      pkgs.source-code-pro
    ];
  };
}
