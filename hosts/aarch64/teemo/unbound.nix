{ pkgs
, ...
}: {
  environment.etc = {
    "unbound/trusted-key.key" = {
      source = "${pkgs.dns-root-data}/root.key";
      user = "unbound";
      group = "unbound";
      mode = "0400";
    };
    "unbound/root.hints" = {
      source = "${pkgs.dns-root-data}/root.hints";
      user = "unbound";
      group = "unbound";
      mode = "0644";
    };
  };

  services.unbound = {
    enable = true;
    enableRootTrustAnchor = false;
    resolveLocalQueries = false;
    settings = {
      server = {
        interface = [ "127.0.0.1" ];
        port = 5335;
        access-control = [ "127.0.0.1 allow" ];
        root-hints = "/etc/unbound/root.hints";
        trust-anchor-file = "/etc/unbound/trusted-key.key";
        # Based on recommended settings in https://docs.pi-hole.net/guides/dns/unbound/#configure-unbound
        harden-glue = true;
        harden-dnssec-stripped = true;
        use-caps-for-id = false;
        prefetch = true;
        edns-buffer-size = 1232;

        hide-identity = true;
        hide-version = true;
      };
    };
  };

  networking.nameservers = [
    "127.0.0.1"
    "::1"
  ];
}
