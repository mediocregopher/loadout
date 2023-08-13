{

  pkgs ? (import ../pkgs.nix).stable {},
  config,

}: rec {

  ohMyZsh = ./oh-my-zsh;

  bin = pkgs.buildEnv {
    name = "mediocregopher-bin";
    paths = [
      (pkgs.stdenv.mkDerivation {
        name = "mediocregopher-default-bin";
        src = ../bin;
        builder = builtins.toFile "builder.sh" ''
          source $stdenv/setup
          mkdir -p "$out"
          cp -rL "$src" "$out"/bin
        '';
      })
    ] ++ (
      builtins.map (cFn: cFn pkgs) config.binExtra
    );
  };

  zshrc = pkgs.writeTextDir ".zshrc" ''

    # oh-my-zsh
    export ZSH=${pkgs.oh-my-zsh}/share/oh-my-zsh
    ZSH_CUSTOM=${./custom}
    ZSH_THEME=mediocregopher
    DISABLE_AUTO_UPDATE=true
    plugins=(git vi-mode)
    source $ZSH/oh-my-zsh.sh

    export PATH=${bin}/bin:$PATH

    #Global stuff shitty programs use
    export EDITOR=~/.nix-profile/bin/nvim

    # GPG is needy
    export GPG_TTY=$(tty)

    . ${./zshrc}
    . ${./aliases}
    . ${pkgs.nix}/etc/profile.d/nix.sh
  '';

  zsh = pkgs.writeScriptBin "zsh" ''
    #!${pkgs.bash}/bin/bash
    ZDOTDIR=${zshrc} exec ${pkgs.zsh}/bin/zsh "$@"
  '';
}
