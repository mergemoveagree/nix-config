{ config
, ...
}: {
  sops.secrets."njalla_acme_content".sopsFile = ./secrets.yml;

  security.acme = {
    acceptTerms = true;
    defaults.email = "uiazagzv@addy.io";
    certs = {
      "jaden0.com" = {
        dnsProvider = "njalla";
        domain = "*.jaden0.com";
        group = "nginx";
        environmentFile = config.sops.secrets."njalla_acme_content".path;
        # Have to set to null or else default is non-null
        webroot = null;
      };
    };
  };

  services.nginx = {
    enable = true;
    virtualHosts = {
      "jaden0.com" = {
        onlySSL = true;
        enableACME = true;
        locations = {
          "/aghome" = {
            proxyPass = "http://127.0.0.1:3003";
            extraConfig = ''
              proxy_cookie_path / /aghome/;
              proxy_redirect / /aghome/;
              proxy_set_header Host $host;
            '';
          };
        };
      };
    };
  };
}
