{

  pkgs ? (import ../pkgs.nix) {},

}: rec {

  goimports = pkgs.buildGoModule rec {
    pname = "goimports";
    version = "v0.1.7";
    src = builtins.fetchGit {
      url = "https://go.googlesource.com/tools";
      rev = "0df0ca0f43117120bd7cc900ebf765f9b799438a";
    };
    vendorSha256 = "1vs4vbl3kh8lbqrm4yqqn27ammlqj7jdbi0ca9s4fkja2sk45ibi";
    subPackages = [ "cmd/goimports" ];
  };

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

  # the gocode-gomod which comes with nixpkgs places the binary at
  # gocode-gomod, we gotta rename it
  gocode = pkgs.stdenv.mkDerivation {
    name = "gocode";
    src = pkgs.gocode-gomod;
    builder = builtins.toFile "builder.sh" ''
      source $stdenv/setup
      mkdir -p "$out"/bin/
      cp "$src"/bin/gocode-gomod "$out"/bin/gocode
    '';
  };

  env = pkgs.buildEnv {
    name = "nvim-env";
    paths = [
      pkgs.vimPlugins.vim-plug
      pkgs.vimPlugins.deoplete-nvim
      pkgs.vimPlugins.deoplete-go
      pkgs.vimPlugins.nerdtree
      pkgs.vimPlugins.nerdtree-git-plugin
      pkgs.vimPlugins.vim-gitgutter
      pkgs.vimPlugins.neomake
      pkgs.vimPlugins.papercolor-theme
      pkgs.vimPlugins.vim-go
      pkgs.vimPlugins.vim-nix

      pkgs.golangci-lint
      pkgs.gopls
      gocode
      goimports
      misspell
    ];
  };

  envPlugins = "${env}/share/vim-plugins";

  init = pkgs.writeText "nvim-init" ''
    source ${envPlugins}/vim-plug/plug.vim

    call plug#begin('${envPlugins}')
    Plug '${envPlugins}/deoplete-nvim'
    Plug '${envPlugins}/deoplete-go', { 'for': 'go' }
    Plug '${envPlugins}/nerdtree', { 'on':  'NERDTreeToggle' }
    Plug '${envPlugins}/nerdtree-git-plugin'
    Plug '${envPlugins}/vim-gitgutter'
    Plug '${envPlugins}/neomake'
    Plug '${envPlugins}/papercolor-theme'
    Plug '${envPlugins}/vim-go', { 'for': 'go' }
    Plug '${envPlugins}/vim-nix', { 'for': 'nix' }
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
    buildInputs = [ pkgs.git nvimRaw ];
    builder = builtins.toFile "builder.sh" ''
      source $stdenv/setup
      mkdir -p "$out"/
      export NVIM_RPLUGIN_MANIFEST="$out"/rplugin.vim
      nvim -c ':UpdateRemotePlugins' -c ':exit' >/dev/null
    '';
  };

  nvim = pkgs.writeScriptBin "nvim" ''
    #!${pkgs.bash}/bin/bash
    export NVIM_RPLUGIN_MANIFEST=${rplugin}/rplugin.vim
    exec ${nvimRaw}/bin/nvim "$@"
  '';

}
