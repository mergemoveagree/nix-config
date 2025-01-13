{ inputs
, pkgs
, ...
}: {
  imports = [ inputs.home-manager.nixosModules.home-manager ];
  home-manager.sharedModules = [ inputs.sops-nix.homeManagerModules.sops ];
  home-manager.extraSpecialArgs = {
    inherit
      inputs
      pkgs
    ;
  };
  home-manager.useGlobalPkgs = true;
}
