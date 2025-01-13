{ inputs
, ...
}: let
  nixvim-setup-overlay = final: prev: { 
    nixvim-neovim = let
      nixvim' = inputs.nixvim.legacyPackages.${final.system};
      nvim = nixvim'.makeNixvimWithModule {
        pkgs = final;
        module = ../home/common/core/nixvim-config;
    };
    in nvim;
  };
in {
  default = final: prev:
    (nixvim-setup-overlay final prev)
  ;
}
