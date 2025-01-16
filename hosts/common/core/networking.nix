{ config
, lib
, ...
}: {
  config = lib.mkIf (! config.hostSpec.isServer) {
    networking.networkmanager.enable = true;
    networking.networkmanager.wifi.backend = "iwd";
    networking.firewall.enable = true;
  };
}
