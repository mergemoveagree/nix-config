{ config
, lib
, ...
}: {
  sops.secrets."njalla_acme_content".sopsFile = lib.custom.relativeToRoot "hosts/secrets.yml";

  security.acme = {
    acceptTerms = true;
    defaults.email = "uiazagzv@addy.io";
    certs = {
      "leftrmodule.com" = {
        dnsProvider = "njalla";
        group = "nginx";
        domain = "*.leftrmodule.com";
        environmentFile = config.sops.secrets."njalla_acme_content".path;
        # Have to set to null or else default is non-null
        webroot = null;
      };
    };
  };
}
