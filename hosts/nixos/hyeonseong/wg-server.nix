{ config
, lib
, pkgs
, ...
}: {
  sops.secrets."hyeonseong_wireguard_private_key".sopsFile = ./secrets.yml;

  boot.kernel.sysctl."net.ipv4.ip_forward" = lib.mkForce 1;

  networking = {
    nat = {
      enable = true;
      externalInterface = config.hostSpec.netInterface;
      internalInterfaces = [ "wg0" ];
    };

    firewall = {
      allowedUDPPorts = [ 51820 2223 ];
      extraCommands = ''
        ${pkgs.iptables}/bin/iptables -t nat -A PREROUTING -p tcp --dport 80 -j DNAT --to-destination 10.100.0.2:80
        ${pkgs.iptables}/bin/iptables -t nat -A PREROUTING -p tcp --dport 443 -j DNAT --to-destination 10.100.0.2:443
        ${pkgs.iptables}/bin/iptables -t nat -A PREROUTING -p tcp --dport 2223 -j DNAT --to-destination 10.100.0.2:2223
      '';
    };

    wireguard = {
      enable = true;
      interfaces.wg0 = {
        ips = [ "10.100.0.1/24" ];
        listenPort = 51820;
        privateKeyFile = config.sops.secrets."hyeonseong_wireguard_private_key".path;
        postSetup = ''
          ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.100.0.0/24 -o ${config.hostSpec.netInterface} -j MASQUERADE
        '';
        postShutdown = ''
          ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.100.0.0/24 -o ${config.hostSpec.netInterface} -j MASQUERADE
        '';
        peers = [
          {
            publicKey = "/9lZDE4gfTvsA5iZGlNux3oxYUX520uQqXguDtGJhCU=";
            allowedIPs = [ "10.100.0.2/32" ];
          }
          {
            publicKey = "ZBWpfR4URU4UoO26ojoqIBoWCqrleuZ73MTDe6GtFAs=";
            allowedIPs = [ "10.100.0.3/32" ];
          }
        ];
      };
    };
  };
}
