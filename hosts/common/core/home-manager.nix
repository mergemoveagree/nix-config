{ inputs
, pkgs
, config
, lib
, ...
}: {
  # TODO: Implement this in a better way :skull:
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  config = lib.mkIf config.hostSpec.enableHomeManager {
    home-manager.extraSpecialArgs = {
      inherit
        inputs
        pkgs
      ;
      hostSpec = config.hostSpec;
    };
    home-manager.useGlobalPkgs = true;
    home-manager.users = lib.foldlAttrs (_: name: _: {
      ${name} = import (lib.custom.relativeToRoot "home/${name}/${config.hostSpec.hostName}.nix");
    }) {} config.userSpec;
  };
}
