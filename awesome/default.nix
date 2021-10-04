{

  pkgs ? (import ../pkgs.nix) {},

}: rec {

  cfg = ./.;
  wp = ../wallpapers;

  dirsLua = pkgs.writeTextDir "dirs.lua" ''
    home_dir = os.getenv("HOME").."/"
    conf_dir = "${cfg}/"
    wp_dir = "${wp}/"
  '';

  awesome = pkgs.writeScriptBin "awesome" ''
    #!${pkgs.bash}/bin/bash

    export BROWSER=/usr/bin/google-chrome

    echo "[$(date)] New awesome session starting" > ~/.awesome.log
    exec ${pkgs.awesome}/bin/awesome \
      -c ${cfg}/rc.lua \
      --search ${dirsLua} \
      --search ${cfg} \
      2>&1 2>>~/.awesome.log
  '';

}
