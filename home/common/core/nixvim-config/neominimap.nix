{ pkgs
, ...
}: let
  neominimap-nvim = pkgs.vimUtils.buildVimPlugin rec {
    pname = "neominimap.nvim";
    version = "3.7.3";
    buildInputs = [ pkgs.code-minimap ];
    src = pkgs.fetchFromGitHub {
      owner = "Isrothy";
      repo = "neominimap.nvim";
      rev = "refs/tags/v${version}";
      hash = "sha256-CEsOXwnYG2jhLSA5oow8EsmmuWRdeS06QiuTTSlfCYc=";
    };
  };
in {
  extraPlugins = [
    neominimap-nvim
  ];

  plugins.gitsigns.enable = true;

  opts = {
    wrap = false;
    sidescrolloff = 36;
  };

  globals.neominimap.__raw = ''
  {
    auto_enable = true,
  }
  '';
}
