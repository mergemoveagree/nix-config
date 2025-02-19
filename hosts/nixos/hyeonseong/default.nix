{ lib
, config
, ...
}: {
  imports = lib.flatten [
    (map lib.custom.relativeToRoot [
      "hosts/common/core"

      "hosts/common/users/user"

      "hosts/common/features/sops.nix"

      "modules/features/wg-server.nix"
    ])
  ];

  hostSpec = {
    hostName = "hyeonseong";
    netInterface = "ens18";
    isServer = true;
    enableHomeManager = false;
  };

  custom-wg-server = {
    enable = true;
    forwardedPorts =  map (port: { address = "10.100.0.2"; inherit port; }) [ 
      80
      443
    ];
    peerPublicKeys = [
      "/9lZDE4gfTvsA5iZGlNux3oxYUX520uQqXguDtGJhCU="
    ];
  };

  services.qemuGuest.enable = true;
  systemd.services.macchanger.enable = lib.mkForce false;

  networking = {
    useDHCP = false;
    firewall.allowedTCPPorts = [ 443 80 ];
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
    nameservers = [ "9.9.9.9" "1.1.1.1" "1.0.0.1" ];
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
