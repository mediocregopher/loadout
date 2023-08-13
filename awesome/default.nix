{

  config,


}: rec {

  pkgs = (import ../pkgs.nix).stable {};
  pkgs2305 = (import ../pkgs.nix).stable2305 {};
  pkgsEdge = (import ../pkgs.nix).edge {};

  # nativeWrap is used for apps which are not installed via nix which don't play
  # nicely with it.
  nativeWrap = pkgs.writeScriptBin "native-wrap" ''
    #!${pkgs.bash}/bin/bash

    unset XDG_CONFIG_DIRS
    unset XDG_DATA_DIRS
    unset GDK_PIXBUF_MODULE_FILE

    exec "$@"
  '';

  browser = pkgs.writeScriptBin "browser" ''
    #!${pkgs.bash}/bin/bash
    exec ${nativeWrap}/bin/native-wrap ${config.browser} "$@"
  '';

  env = pkgs.buildEnv {
    name = "awesome-env";
    paths = [

      pkgs.awesome
      pkgs.tela-icon-theme

      nativeWrap
      browser

      pkgs.xorg.xrandr
      pkgs.xsel
      pkgs.pavucontrol
      pkgs.xdg-utils
      pkgs.arandr

      pkgs.i3lock
      pkgs.scrot
      pkgs.feh
      pkgs.brightnessctl

      pkgs.cbatticon
      pkgs.phwmon

      pkgs.castor
      pkgs2305.libreoffice
      pkgs.gimp
      pkgs.inkscape
      pkgs.vlc
      pkgs.sylpheed

      pkgsEdge.lagrange
    ];
  };

  wp = ../wallpapers;

  dirsLua = pkgs.writeTextDir "dirs.lua" ''
    home_dir = os.getenv("HOME").."/"
    bin_dir = "${./bin}/"
    share_dir = "${./share}/"
    wp_dir = "${wp}/"
  '';

  awesome = pkgs.writeScriptBin "awesome" ''
    #!${pkgs.bash}/bin/bash

    export BROWSER=${browser}/bin/browser

    # Turn off powersaving (fuck the environment)
    xset -dpms
    xset s off

    export PATH=${env}/bin:$PATH

    export XDG_CONFIG_DIRS=${./config}

    export XDG_DATA_DIRS=${env}/share
    export XDG_DATA_DIRS=$XDG_DATA_DIRS:/home/mediocregopher/.nix-profile/share

    ${config.awesome.startupExtra}

    # HACK: This sleep is here because phwmon actually creates a separate tray
    # icon for each thing it monitors, and if the process runs at the same time
    # as another process which creates a tray icon they can get interleaved.
    (sleep 5 && phwmon.py) &

    ############################################################################
    # Init awesome

    data_dir="$HOME/.local/share/awesome";
    mkdir -p "$dataDir"

    log_dir="$data_dir"/logs
    mkdir -p $log_dir

    # only keep last N awesome.log files
    ls "$log_dir" | sort -n | head -n -5 | while read f; do rm "$log_dir"/"$f"; done

    ############################################################################
    # Exec

    this_log=$log_dir/awesome.$(date '+%Y%m%d.%H%M%S').log

    echo "New awesome session starting" > $this_log

    exec awesome \
      -c ${./rc.lua} \
      --search ${dirsLua} \
      --search ${./share} \
      --search ${env}/share/awesome/themes \
      2>&1 2>>$this_log
  '';
}
