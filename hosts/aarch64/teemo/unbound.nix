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

        # Optimization
        num-threads = 4;
        msg-cache-slabs = 4;
        rrset-cache-slabs = 4;
        infra-cache-slabs = 4;
        key-cache-slabs = 4;
        msg-cache-size = "50m";
        rrset-cache-size = "100m";
        outgoing-range = 206;
        num-queries-per-thread = 103;
        so-rcvbuf = "4m";
        so-sndbuf = "4m";
        so-reuseport = true;

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

  # Increase kernel buffer for unbound
  boot.kernel.sysctl = {
    "net.core.rmem_max" = 4194304;
    "net.core.wmem_max" = 4194304;
    "net.core.somaxconn" = 256;
    "net.ipv4.tcp_max_syn_backlog" = 256;
  };
}
