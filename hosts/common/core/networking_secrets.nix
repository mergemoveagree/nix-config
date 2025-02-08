{ config
, lib
, ...
}: {
  # FIXME: Will fail without sops input
  sops.secrets = lib.mkIf config.hostSpec.isServer {
    "duckdns_domain".sopsFile = lib.custom.relativeToRoot "hosts/networking_secrets.yml";
    "duckdns_token".sopsFile = lib.custom.relativeToRoot "hosts/networking_secrets.yml";
    "njalla_acme_content".sopsFile = lib.custom.relativeToRoot "hosts/networking_secrets.yml";
  };
}
