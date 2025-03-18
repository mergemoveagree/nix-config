{ lib
, config
, inputs
, pkgs
, ...
}: {
  imports = lib.flatten [
    inputs.hardware.nixosModules.raspberry-pi-4

    (map lib.custom.relativeToRoot [
      "hosts/common/core"

      "hosts/common/users/user"

      "hosts/common/features/sops.nix"
    ])

    ./acme.nix
    ./adguard.nix
    ./conduwuit.nix
    ./fail2ban.nix
    ./nginx.nix
    ./ntfy.nix
    ./unbound.nix
    ./njalla-ddns.nix
    ./wg-client.nix
  ];

  hostSpec = {
    hostName = "teemo";
    netInterface = "end0";
    enableZsh = true;
    isServer = true;
    hasRTC = false;
    enableHomeManager = false;
  };

  hardware.raspberry-pi."4".apply-overlays-dtmerge.enable = true;
  boot.initrd.systemd.tpm2.enable = false;
  systemd.services.macchanger.enable = lib.mkForce false;

  environment.systemPackages = with pkgs; [
    dig
  ];

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
    firewall.allowedTCPPorts = [ 443 80 2223 ];
  };

  sops.secrets = {
    "teemo_initrd_ed25519_private_key".sopsFile = lib.custom.relativeToRoot "hosts/aarch64/teemo/secrets.yml";
    "teemo_initrd_rsa_private_key".sopsFile = lib.custom.relativeToRoot "hosts/aarch64/teemo/secrets.yml";
    "teemo_initrd_wireguard_private_key".sopsFile = lib.custom.relativeToRoot "hosts/aarch64/teemo/secrets.yml";
  };

  users.users = {
    root.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMXp1dmKZUAQcH9DG6vinh37b9MxhmaArAu/fzNGj1Du "
    ];
    user.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHNRvHW+ueHG+Gpd/uWr1PTQ9gSZ+z9K1LsrprEMQPO2 user@asrock"
    ];
  };

  services.openssh = {
    enable = true;
    openFirewall = true;
    settings.PermitRootLogin = lib.mkForce "prohibit-password";
  };

  # initrd SSH
  boot.kernelParams = [ "ip=192.168.1.3::192.168.1.254:255.255.255.0:teemo::none" ];
  boot.initrd.secrets = {
    "/etc/secrets/30-wg-initrd.key" = config.sops.secrets."teemo_initrd_wireguard_private_key".path;
  };
  boot.initrd.availableKernelModules = [
    "wireguard"
    "genet"
    "brcmfmac"
    "algif_skcipher"
    "xchacha20"
    "adiantum"
    "aes_neon_bs"
    "sha256"
    "nhpoly1305"
    "dm-crypt"
  ];
  boot.initrd.network = {
    enable = true;
    ssh = {
      enable = true;
      port = 2222;
      hostKeys = [
        config.sops.secrets."teemo_initrd_ed25519_private_key".path
        config.sops.secrets."teemo_initrd_rsa_private_key".path
      ];
      authorizedKeys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHNRvHW+ueHG+Gpd/uWr1PTQ9gSZ+z9K1LsrprEMQPO2 user@asrock"
      ];
      shell = lib.mkIf (!config.boot.initrd.systemd.enable) "/bin/cryptsetup-askpass";
    };
  };
  boot.initrd.systemd = {
    enable = true;
    #users.root.shell = lib.mkIf config.boot.initrd.systemd.enable "/bin/systemd-tty-ask-password-agent";
    initrdBin = [
      pkgs.iproute2
      pkgs.unixtools.ping
      pkgs.wireguard-tools
    ];
    network = {
      netdevs."30-wg-initrd" = {
        netdevConfig = {
          Kind = "wireguard";
          Name = "wg-initrd";
        };
        wireguardConfig = { PrivateKeyFile = "/etc/secrets/30-wg-initrd.key"; };
        wireguardPeers = [{
          PublicKey = "F12Gr+EGqxNdgB5iUnNrCrrdVwWJKQH6SdZ8gOJO0Q8=";
          AllowedIPs = [ "10.100.0.0/24" ];
          Endpoint = "65.87.7.78:51820";
          PersistentKeepalive = 25;
        }];
      };
      networks."30-wg-initrd" = {
        name = "wg-initrd";
        addresses = [{ Address = "10.100.0.5/24"; }];
      };
    };
  };
  boot.initrd.systemd.services.wg-initrd-key-perms = {
    description = "Fix wireguard private key permissions";
    wantedBy = [ "initrd.target" ];
    before = [ "systemd-networkd.service" ];
    after = [ "initrd-nixos-copy-secrets.service" ];
    unitConfig.DefaultDependencies = "no";
    serviceConfig.Type = "oneshot";
    script = ''
      chmod 0400 /etc/secrets/30-wg-initrd.key
      chown systemd-network: /etc/secrets/30-wg-initrd.key
    '';
  };
}
