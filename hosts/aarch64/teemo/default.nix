{ inputs
, lib
, ...
}: {
  imports = lib.flatten [
    inputs.hardware.nixosModules.raspberry-pi-4

    (map lib.custom.relativeToRoot [
      "hosts/common/core"

      "hosts/common/users/user"

      "hosts/common/features/sops.nix"
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
      interface = "eno0";
    };
  };

  users.users.user.openssh.authorizedKeys.keys = [
    (builtins.readFile ./authorized_keys/user.pub)
  ];

  boot.initrd.availableKernelModules = [ "virtio-pci" ];

  boot.initrd.network = {
    enable = true;
    ssh = {
      enable = true;
      port = 2222;
      hostKeys = [
        ./teemo_initrd_ed25519_key
        ./teemo_initrd_rsa_key
      ];
      authorizedKeyFiles = [
        ./authorized_keys/user.pub
      ];
    };
    postCommands = ''
      echo 'cryptsetup-askpass' >> /root/.profile
    '';
  };
  boot.kernelParams = [ "ip=192.168.1.3::192.168.1.254::teemo::none" ];
}
