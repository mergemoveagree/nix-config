{ config
, ...
}: {
  sops.secrets."thinkpadx1_wireguard_private_key".sopsFile = ./secrets.yml;

  networking = {
    firewall.allowedUDPPorts = [ 51820 ];
    wireguard = {
      enable = true;
      interfaces.wg0 = {
        ips = [ "10.100.0.4/24" ];
        listenPort = 51820;
        privateKeyFile = config.sops.secrets."thinkpadx1_wireguard_private_key".path;
        peers = [
          {
            publicKey = "F12Gr+EGqxNdgB5iUnNrCrrdVwWJKQH6SdZ8gOJO0Q8=";
            allowedIPs = [ "10.100.0.0/24" ];
            endpoint = "65.87.7.78:51820";
            persistentKeepalive = 25;
          }
        ];
      };
    };
  };
}
