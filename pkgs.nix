let

  src = builtins.fetchTarball {
    name = "nixpkgs-2105";
    url = "https://github.com/nixos/nixpkgs/archive/7e9b0dff974c89e070da1ad85713ff3c20b0ca97.tar.gz";
    sha256 = "1ckzhh24mgz6jd1xhfgx0i9mijk6xjqxwsshnvq789xsavrmsc36";
  };

  normalPkgs = (import src) {};

  config = {
    allowUnfree = true;
    packageOverrides = pkgs: {

      go = builtins.fetchTarball {
        url = "https://golang.org/dl/go1.17.1.linux-amd64.tar.gz";
        sha256 = "1196h1jx9cn5ks1y9r95z0q2s6m6ssvnx7jd34g435jvxjgb2c94";
      };

      nixgl = let

        src = builtins.fetchTarball {
          name = "nixgl-unstable";
          url = "https://github.com/guibou/nixGL/archive/51f19871a31b15b482ac4c80976da173289e77fb.tar.gz";
          sha256 = "0dj2apbx5iqvkiixyz1dzx4id51iw9s2isp1f9x60a03f5sqcvvi";
        };

        nixgl = (import src) {
          inherit pkgs;
          enable32bits = false;
        };

      in nixgl.nixGLIntel;

    };
  };

in pkgsArg:
  (import src) (
    normalPkgs.lib.attrsets.recursiveUpdate { config = config; } pkgsArg
  )
