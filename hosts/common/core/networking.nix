{ config
, lib
, ...
}: {
  networking = {
    firewall = {
      enable = true;
      allowPing = config.hostSpec.isServer;
    };
    networkmanager = lib.mkIf (! config.hostSpec.isServer) {
      enable = true;
      wifi.backend = "iwd";
    };
  };
}
