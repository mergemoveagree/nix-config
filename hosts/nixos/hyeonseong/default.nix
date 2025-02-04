{ lib
, config
, ...
}: {
  imports = lib.flatten [
    (map lib.custom.relativeToRoot [
      "hosts/common/core"

      "hosts/common/users/user"

      "hosts/common/features/sops.nix"
    ])

    ./nginx.nix
  ];

  hostSpec = {
    hostName = "hyeonseong";
    netInterface = "ens18";
    isServer = true;
    enableHomeManager = false;
  };

  networking = {
    interfaces.${config.hostSpec.netInterface} = {
      ipv4.addresses = [{
        address = "185.141.216.3";
        prefixLength = 24;
      }];
    };
    defaultGateway = {
      address = "185.141.216.1";
      interface = config.hostSpec.netInterface;
    };
  };

  # Legacy boot
  boot.loader = {
    systemd-boot.enable = lib.mkForce false;
    efi.efiSysMountPoint = lib.mkForce "/boot/efi";
    grub = {
      enable = true;
    };
  };
}
