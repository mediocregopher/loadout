{

  pkgsSrc ? ./pkgs.nix,

}: let

  nixBundle = builtins.fetchGit {
    url = "https://github.com/matthewbauer/nix-bundle.git";
    rev = "223f4ffc4179aa318c34dc873a08cb00090db829";
  };

  appimageTop = (import "${nixBundle}/appimage-top.nix") {
    nixpkgs' = pkgsSrc;
  };

in { name, target }:
  appimageTop.appimage (appimageTop.appdir { inherit name target; })
