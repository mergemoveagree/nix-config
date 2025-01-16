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
    netInterface = "eno0";
    enableZsh = true;
    isServer = true;
  };

  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.initrd.systemd.enable = lib.mkForce false;

  networking = {
    interfaces.eno0 = {
      ipv4.addresses = [{
        address = "192.168.1.3";
        prefixLength = 24;
      }];
    };
    defaultGateway = {
      address = "192.168.1.254";
      interface = "ens3";
    };
  };
}
