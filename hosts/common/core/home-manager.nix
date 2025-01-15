{ inputs
, pkgs
, config
, ...
}: {
  imports = [ inputs.home-manager.nixosModules.home-manager ];
  home-manager.sharedModules = [ inputs.sops-nix.homeManagerModules.sops ];
  home-manager.extraSpecialArgs = {
    inherit
      inputs
      pkgs
    ;
    hostSpec = config.hostSpec;
  };
  home-manager.useGlobalPkgs = true;
}
