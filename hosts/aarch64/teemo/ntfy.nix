{
  services.ntfy-sh = {
    enable = true;
    settings = {
      base-url = "http://ntfy.leftrmodule.com";
      behind-proxy = true;
      listen-http = ":2586";
    };
  };

  services.nginx.virtualHosts."ntfy.leftrmodule.com" = {
    forceSSL = true;
    useACMEHost = "ntfy.leftrmodule.com";
    locations."/" = {
      proxyPass = "http://127.0.0.1:2586";
      extraConfig = ''
        proxy_connect_timeout 3m;
        proxy_send_timeout 3m;
        proxy_read_timeout 3m;
        client_max_body_size 0;
      '';
    };
  };
}
