{ pkgs
, ...
}: {
  environment.etc."unbound/root.hints" = {
    source = "${pkgs.dns-root-data}/root.hints";
    user = "unbound";
    group = "unbound";
    mode = "0644";
  };

  services.unbound = {
    enable = true;
    enableRootTrustAnchor = true;
    resolveLocalQueries = true;
    settings = {
      server = {
        interface = [ "127.0.0.1" ];
        port = 5335;
        access-control = [ "127.0.0.1 allow" ];
        root-hints = "/etc/unbound/root.hints";
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
}
