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
        forceSSL = true;
        enableACME = true;
        locations = {
          "/aghome" = {
            proxyPass = "http://127.0.0.1:3003";
            extraConfig = ''
              proxy_set_header Host $host;
              proxy_set_header X-Real-IP $remote_addr;
              proxy_set_header X-Forwarded-Host $host;
              proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
              proxy_set_header X-Forwarded-Proto $scheme;
              proxy_set_header X-Forwarded-Protocol $scheme;
            '';
          };
        };
      };
    };
  };

  networking.firewall = {
    allowedTCPPorts = [ 443 80 ];
  };
}
