{ inputs
, lib
, ...
}: {
  imports = lib.flatten [
    inputs.hardware.nixosModules.raspberry-pi-4

    (map lib.custom.relativeToRoot [
      "hosts/common/core"

      "hosts/common/users/user"
    ])

    ./unbound.nix
    ./adguard.nix
  ];

  hostSpec = {
    hostName = "teemo";
    netInterface = "eth0";
    enableZsh = true;
    isServer = true;
  };

  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.initrd.systemd.enable = lib.mkForce false;
}
