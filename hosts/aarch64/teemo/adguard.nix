{
  services.adguardhome = {
    enable = true;
    allowDHCP = false;
    host = "127.0.0.1";
    port = 3003;
    mutableSettings = false;
    openFirewall = true;
    settings = {
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

