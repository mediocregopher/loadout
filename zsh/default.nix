{

  pkgs ? (import ../pkgs.nix) {},

}: rec {

  ohMyZsh = ./oh-my-zsh;

  zshrc = pkgs.writeTextDir ".zshrc" ''

    # oh-my-zsh
    export ZSH=${pkgs.oh-my-zsh}/share/oh-my-zsh
    ZSH_CUSTOM=${./custom}
    ZSH_THEME=mediocregopher
    DISABLE_AUTO_UPDATE=true
    plugins=(git vi-mode)
    source $ZSH/oh-my-zsh.sh

    PATH=${../bin}:$PATH

    . ${./zshrc}
    . ${./env}
    . ${./aliases}
    . ${pkgs.nix}/etc/profile.d/nix.sh
  '';

  zsh = pkgs.writeScriptBin "zsh" ''
    #!${pkgs.bash}/bin/bash
    ZDOTDIR=${zshrc} exec ${pkgs.zsh}/bin/zsh "$@"
  '';
}
