{ config
, ...
}: {
  sops.secrets."teemo_wireguard_private_key".sopsFile = ./secrets.yml;

  networking = {
    firewall.allowedUDPPorts = [ 51820 ];
    interfaces.${config.hostSpec.netInterface}.ipv4.routes = [{
      address = "185.141.216.3";
      prefixLength = 32;
      via = "192.168.1.254";
    }];
    wireguard = {
      enable = true;
      interfaces.wg0 = {
        ips = [ "10.100.0.2/24" ];
        listenPort = 51820;
        privateKeyFile = config.sops.secrets."teemo_wireguard_private_key".path;
        peers = [
          {
            publicKey = "F12Gr+EGqxNdgB5iUnNrCrrdVwWJKQH6SdZ8gOJO0Q8=";
            allowedIPs = [ "10.100.0.0/24" ];
            endpoint = "185.141.216.3";
            persistentKeepalive = 25;
          }
        ];
      };
    };
  };
}
