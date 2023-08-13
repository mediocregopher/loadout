{

  config,

  pkgs ? (import ../pkgs.nix).stable2305 {},
  zsh ? pkgs.zsh,

}: rec {

  defaultXDGOpenRules = [
    {
      name = "open-url";
      pattern = "(ipfs:|ipns:|magnet:|mailto:|gemini:|gopher:|https:|http:|news:|file:|git:|ssh:|ftp:)[^<>\"\\s{-}\\^⟨⟩`]+";
      xdgOpen = "$1";
    }
  ];

  xdgOpenRules = defaultXDGOpenRules ++ config.alacritty.xdgOpenRules;

  hints = {
    enabled = (builtins.map (r:
      {
        regex = r.pattern;
        hyperlinks = true;
        command = (pkgs.writeShellScript "alacritty-hints-${r.name}" ''
          xdg-open "${r.xdgOpen}"
        '');
        post_processing = true;
        mouse.enabled = true;
      }
    ) xdgOpenRules);
  };

  configFile = pkgs.writeText "alacritty-config" (
    builtins.replaceStrings
      ["$HINTS"]
      [(builtins.toJSON hints)]
      (builtins.readFile ./alacritty.yml)
    );

  alacritty = pkgs.writeScriptBin "alacritty" ''
    #!${pkgs.bash}/bin/bash

    exec ${pkgs.nixgl}/bin/nixGL ${pkgs.alacritty}/bin/alacritty \
      -o font.size=${builtins.toString config.alacritty.fontSize} \
      --config-file ${configFile} \
      -e "${zsh}/bin/zsh"
  '';
}
