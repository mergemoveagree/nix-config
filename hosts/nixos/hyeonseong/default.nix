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

  services.qemuGuest.enable = true;
  systemd.services.macchanger.enable = lib.mkForce false;

  networking = {
    useDHCP = false;
    interfaces.${config.hostSpec.netInterface} = {
      useDHCP = false;
      ipv4.addresses = [{
        address = "65.87.7.200";
        prefixLength = 24;
      }];
      ipv6.addresses = [{
        address = "2a0f:85c1:356:1e3e::1";
        prefixLength = 48;
      }];
    };
    defaultGateway = {
      address = "65.87.7.1";
      interface = config.hostSpec.netInterface;
    };
    defaultGateway6 = {
      address = "2a0f:85c1:356::1";
      interface = config.hostSpec.netInterface;
    };
    search = [ "us.kyun.network" ];
    nameservers = [ "9.9.9.9" ];
  };

  services.openssh.settings.PermitRootLogin = lib.mkForce "prohibit-password";

  users.users = {
    root.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK9QLV5cgHgjnbQsDWvjRfawrqFJn0u860YLgnAxyILd "
    ];
    user.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICOlK3pu/w0HL9QKUJl8eMGZA7sWfK+PZyJ/MygaorEK "
    ];
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
