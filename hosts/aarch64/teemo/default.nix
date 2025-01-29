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
    hasRTC = false;
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
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHNRvHW+ueHG+Gpd/uWr1PTQ9gSZ+z9K1LsrprEMQPO2 user@asrock"
  ];

  boot.initrd.availableKernelModules = [ "genet" ];

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
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHNRvHW+ueHG+Gpd/uWr1PTQ9gSZ+z9K1LsrprEMQPO2 user@asrock"
      ];
      shell = lib.mkIf (!config.boot.initrd.systemd.enable) "/bin/cryptsetup-askpass";
    };
  };
  boot.kernelParams = [ "ip=192.168.1.3::::teemo::none" ];
  boot.initrd.systemd.users.root.shell = lib.mkIf (config.boot.initrd.systemd.enable) "/bin/systemd-tty-ask-password-agent";
}
