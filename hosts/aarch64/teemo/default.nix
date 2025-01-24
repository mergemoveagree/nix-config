{ lib
, config
, ...
}: {
  imports = lib.flatten [
    (map lib.custom.relativeToRoot [
      "hosts/common/core"

      "hosts/common/users/user"

      "hosts/common/features/sops.nix"
      "hosts/common/features/home-manager.nix"
    ])

    ./unbound.nix
    ./adguard.nix
  ];

  hostSpec = {
    hostName = "teemo";
    netInterface = "enabcm6e4ei0";
    enableZsh = true;
    isServer = true;
  };

  networking = {
    interfaces.${config.hostSpec.netInterface} = {
      ipv4.addresses = [{
        address = "192.168.1.3";
        prefixLength = 24;
      }];
    };
    defaultGateway = {
      address = "192.168.1.254";
      interface = config.hostSpec.netInterface;
    };
  };

  users.users.user.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIYIe+a9svbtfP/ebUBVMBnwMA/C7+zIMa4PTtrkIf4x user@asrock"
  ];

  boot.initrd.availableKernelModules = [ "virtio-pci" "genet" ];

  boot.initrd.network = {
    enable = true;
    ssh = {
      enable = true;
      port = 2222;
      hostKeys = [
        ./teemo_initrd_ed25519_key
        ./teemo_initrd_rsa_key
      ];
      authorizedKeys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIYIe+a9svbtfP/ebUBVMBnwMA/C7+zIMa4PTtrkIf4x user@asrock"
      ];
    };
  };
  boot.kernelParams = [ "ip=192.168.1.3::::teemo::none" ];
}
