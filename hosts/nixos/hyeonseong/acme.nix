{ config
, ...
}: {
  sops.secrets."njalla_acme_content".sopsFile = ./secrets.yml;

  security.acme = {
    acceptTerms = true;
    defaults.email = "uiazagzv@addy.io";
    certs = {
      "leftrmodule.com" = {
        domain = "*.leftrmodule.com";
        group = "nginx";
        dnsProvider = "njalla";
        environmentFile = config.sops.secrets."njalla_acme_content".path;
      };
    };
  };
}
