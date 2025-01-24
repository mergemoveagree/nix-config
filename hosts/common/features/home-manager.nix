{ inputs
, pkgs
, config
, lib
, ...
}: {
  imports = [ inputs.home-manager.nixosModules.home-manager ];
  home-manager.sharedModules = lib.optional (inputs ? "sops-nix") inputs.sops-nix.homeManagerModules.sops;
  home-manager.extraSpecialArgs = {
    inherit
      inputs
      pkgs
    ;
    hostSpec = config.hostSpec;
  };
  home-manager.useGlobalPkgs = true;
}
