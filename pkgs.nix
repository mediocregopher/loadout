rec {

  mkPkgs = src: let

    normalPkgs = (import src) {};

    config = {
      allowUnfree = true;
      packageOverrides = pkgs: {

        nixgl = let

          src = builtins.fetchTarball {
            name = "nixgl-unstable";
            url = "https://github.com/guibou/nixGL/archive/7165ffbccbd2cf4379b6cd6d2edd1620a427e5ae.tar.gz";
            sha256 = "1wc85xqnq2wb008y9acb29jbfkc242m9697g2b8j6q3yqmfhrks1";
          };

          nixgl = (import src) {
            inherit pkgs;
            enable32bits = false;
          };

        in nixgl.auto.nixGLDefault;

      };
    };

  in pkgsArg: (import src) (
    normalPkgs.lib.attrsets.recursiveUpdate { config = config; } pkgsArg
  );

  stable = mkPkgs (builtins.fetchTarball {
    name = "nixpkgs-2105";
    url = "https://github.com/nixos/nixpkgs/archive/7e9b0dff974c89e070da1ad85713ff3c20b0ca97.tar.gz";
    sha256 = "1ckzhh24mgz6jd1xhfgx0i9mijk6xjqxwsshnvq789xsavrmsc36";
  });

  stable2305 = mkPkgs (builtins.fetchTarball {
    name = "nixpkgs-2305";
    url = "https://github.com/nixos/nixpkgs/archive/4ecab3273592f27479a583fb6d975d4aba3486fe.tar.gz";
    sha256 = "sha256:10wn0l08j9lgqcw8177nh2ljrnxdrpri7bp0g7nvrsn9rkawvlbf";
  });

  edge = mkPkgs (builtins.fetchTarball {
    name = "nixpkgs-edge";
    url = "https://github.com/nixos/nixpkgs/archive/f9418c4c7fab906c52ae07cf27a618de7722d1e9.tar.gz";
    sha256 = "sha256:067m1gzj1n06m3anshwgabd1liaja8gcvd90spmnyi3a6vhqdvq0";
  });
}
