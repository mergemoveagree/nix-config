{ pkgs
, ...
}: let
  fqdn = "matrix.leftrmodule.com";
  baseUrl = "https://${fqdn}";
  clientConfig."m.homeserver".base_url = baseUrl;
  serverConfig."m.server" = "${fqdn}:443";
  mkWellKnown = data: ''
    default_type application/json;
    add_header Access-Control-Allow-Origin *;
    return 200 '${builtins.toJSON data}';
  '';
in {
  # WARN: Must open ports 80 and 443 somewhere else
  # WARN: Must set up certificates through ACME service
  services.nginx.virtualHosts = {
    "leftrmodule.com" = {
      enableACME = true;
      acmeRoot = null;
      forceSSL = true;
      locations = {
        "= /.well-known/matrix/server".extraConfig = mkWellKnown serverConfig;
        "= /.well-known/matrix/client".extraConfig = mkWellKnown clientConfig;
      };
    };
    "${fqdn}" = {
      enableACME = true;
      forceSSL = true;
      acmeRoot = null;
      locations = {
        "/".extraConfig = ''
          return 404;
        '';
        "/_matrix".proxyPass = "http://[::1]:8008";
        "._synapse/client".proxyPass = "http://[::1]:8008";
      };
    };
    "element.leftrmodule.com" = {
      enableACME = true;
      acmeRoot = null;
      forceSSL = true;
      serverAliases = [
        "element.${fqdn}"
      ];
      root = pkgs.element-web.override {
        conf.default_server_config = clientConfig;
      };
    };
  };
}
