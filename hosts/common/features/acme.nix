{ config
, ...
}: {
  # FIXME: Will fail without networking secrets
  security.acme = {
    acceptTerms = true;
    defaults = {
      email = "uiazagzv@addy.io";
      dnsProvider = "njalla";
      group = "nginx";
      environmentFile = config.sops.secrets."njalla_acme_content".path;
    };
  };
}
