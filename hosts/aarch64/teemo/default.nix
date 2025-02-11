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

    ./matrix-synapse
    ./adguard.nix
    ./nginx.nix
    ./unbound.nix
    ./njalla-ddns.nix
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
    nftables.tables = {
      firewall = {
        family = "inet";
        content = ''
          chain inbound_ipv4 {
            icmp type echo-request limit rate 5/second accept
          }

          chain inbound_ipv6 {
            icmpv6 type { nd-neighbor-solicit, nd-router-advert, nd-neighbor-advert } accept
          }

          chain inbound {
            type filter hook input priority 0;
            policy drop;
            ct state invalid counter drop comment "early drop of invalid packets"
            ct state {established, related} counter accept comment "accept all connections related to connections made by us"
            iifname lo accept comment "accept loopback"
            iif != lo ip daddr 127.0.0.1/8 counter drop comment "drop connections to loopback not coming from loopback"
            iif != lo ip6 daddr ::1/128 counter drop comment "drop connections to loopback not coming from loopback"
            ip protocol icmp counter accept comment "accept all ICMP types"
            meta l4proto ipv6-icmp counter accept comment "accept all ICMP types"
            tcp dport 22 counter accept comment "accept SSH"
            ip saddr 65.87.7.200/24 tcp dport { 80, 443 } accept comment "accept connections to 65.87.7.200"
            counter comment "count dropped packets"
          }
        '';
      };
    };
  };

  sops.secrets = {
    "teemo_initrd_ed25519_private_key".sopsFile = lib.custom.relativeToRoot "hosts/aarch64/teemo/secrets.yml";
    "teemo_initrd_rsa_private_key".sopsFile = lib.custom.relativeToRoot "hosts/aarch64/teemo/secrets.yml";
  };

  users.users = {
    root.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMXp1dmKZUAQcH9DG6vinh37b9MxhmaArAu/fzNGj1Du "
    ];
    user.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHNRvHW+ueHG+Gpd/uWr1PTQ9gSZ+z9K1LsrprEMQPO2 user@asrock"
    ];
  };

  services.openssh.settings.PermitRootLogin = lib.mkForce "prohibit-password";

  boot.initrd.availableKernelModules = [ "genet" ];

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
  boot.kernelParams = [ "ip=192.168.1.3::::teemo::none" ];
  boot.initrd.systemd.users.root.shell = lib.mkIf (config.boot.initrd.systemd.enable) "/bin/systemd-tty-ask-password-agent";

  environment.etc."resolv.conf".text = ''
    nameserver 9.9.9.9
  '';
}
