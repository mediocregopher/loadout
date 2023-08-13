{}: rec {

  pkgs = (import ../pkgs.nix).stable2305 {};

  misspell = pkgs.buildGoPackage rec {
    pname = "misspell";
    version = "0.3.4";
    goPackagePath = "github.com/client9/misspell";

    src = pkgs.fetchFromGitHub {
      owner = "client9";
      repo = "misspell";
      rev = "v${version}";
      sha256 = "1vwf33wsc4la25zk9nylpbp9px3svlmldkm0bha4hp56jws4q9cs";
    };

    goDeps = ./misspellDeps.nix;
  };

  env = pkgs.buildEnv {
    name = "nvim-env";
    paths = [
      pkgs.shellcheck
      misspell
    ];
  };

  envPlugins = "${env}/share/vim-plugins";

  init = pkgs.writeText "nvim-init" ''
    source ${pkgs.vimPlugins.vim-plug}/plug.vim

    call plug#begin()
    Plug '${pkgs.vimPlugins.deoplete-nvim}'
    Plug '${pkgs.vimPlugins.nerdtree}', { 'on':  'NERDTreeToggle' }
    Plug '${pkgs.vimPlugins.nerdtree-git-plugin}'
    Plug '${pkgs.vimPlugins.vim-gitgutter}'
    Plug '${pkgs.vimPlugins.neomake}'
    Plug '${pkgs.vimPlugins.papercolor-theme}'
    Plug '${pkgs.vimPlugins.vim-go}', { 'for': 'go' }
    Plug '${pkgs.vimPlugins.vim-nix}', { 'for': 'nix' }
    Plug '${pkgs.vimPlugins.rust-vim}', { 'for': 'rust' }
    call plug#end()

    source ${./init.vim}
  '';

  nvimRaw = pkgs.writeScriptBin "nvim" ''
    #!${pkgs.bash}/bin/bash
    export PATH=${env}/bin:$PATH
    exec ${pkgs.neovim}/bin/nvim -u ${init} "$@"
  '';

  rplugin = pkgs.stdenv.mkDerivation {
    name = "nvim-rplugin";
    buildInputs = [ pkgs.git pkgs.tree nvimRaw ];
    builder = builtins.toFile "builder.sh" ''
      source $stdenv/setup
      mkdir -p "$out"/
      export NVIM_RPLUGIN_MANIFEST="$out"/rplugin.vim
      nvim -i NONE -c ':UpdateRemotePlugins' -c ':exit' >/dev/null
    '';
  };

  nvim = pkgs.writeScriptBin "nvim" ''
    #!${pkgs.bash}/bin/bash
    export NVIM_RPLUGIN_MANIFEST=${rplugin}/rplugin.vim
    exec ${nvimRaw}/bin/nvim "$@"
  '';

}
