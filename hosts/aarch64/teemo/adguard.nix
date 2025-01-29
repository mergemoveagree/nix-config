{ config
, ...
}: {
  services.adguardhome = {
    enable = true;
    host = "127.0.0.1";
    port = 3003;
    mutableSettings = false;
    openFirewall = true;
    settings = {
      dhcp = {
        enabled = true;
        interface_name = config.hostSpec.netInterface;
        dhcpv4 = {
          gateway_ip = "192.168.1.254";
          subnet_mask = "255.255.255.0";
          range_start = "192.168.1.64";
          range_end = "192.168.1.253";
        };
      };
      dns = {
        bind_hosts = [
          "127.0.0.1"
          "::1"
        ];
        upstream_dns = [
          "127.0.0.1:5335"
        ];
        bootstrap_dns = [];
      };
      filtering = {
        protection_enabled = true;
        filtering_enabled = true;
        parental_enabled = false;
        safe_search = {
          enabled = false;
        };
      };
      # Unbound will do DNSSEC already
      enable_dnssec = false;

      # The following notation uses map
      # to not have to manually create {enabled = true; url = "";} for every filter
      # This is, however, fully optional
      filters = map(url: { enabled = true; url = url; }) [
        "https://adguardteam.github.io/HostlistsRegistry/assets/filter_9.txt"  # The Big List of Hacked Malware Web Sites
        "https://adguardteam.github.io/HostlistsRegistry/assets/filter_11.txt"  # malicious url blocklist
      ];
    };
  };

  networking.firewall = {
    allowedTCPPorts = [3003 80];
    allowedUDPPorts = [53];
  };
}

