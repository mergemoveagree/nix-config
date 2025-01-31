{ lib
, outputs
, config
, ...
}: {
  imports = lib.custom.scanPaths ./.
  ++ lib.flatten [
    (map lib.custom.relativeToRoot [
      "modules/core"
      "hosts/common/users/admin"
    ])
  ];

  nixpkgs.overlays = builtins.attrValues outputs.overlays;

  networking.hostName = config.hostSpec.hostName;

  time.timeZone = "US/Central";

  system.stateVersion = "24.05";
}
