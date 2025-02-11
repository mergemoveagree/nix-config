{ config
, lib
, ...
}: {
  networking = {
    nftables.enable = true;
    firewall.enable = true;
    networkmanager = lib.mkIf (! config.hostSpec.isServer) {
      enable = true;
      wifi.backend = "iwd";
    };
  };
}
