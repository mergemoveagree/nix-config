{ inputs
, pkgs
, ...
}: let
  nixvim' = inputs.nixvim.legacyPackages.${pkgs.system};
  nvim = nixvim'.makeNixvimWithModule {
    inherit pkgs;
    module = ./config;
  };
in {
  imports = [ inputs.nixvim.homeMangerModules.nixvim ];

  home.packages = [
    nvim
  ];
}
