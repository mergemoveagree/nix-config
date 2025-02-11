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
  services.nginx.virtualHosts = {
    "leftrmodule.com" = {
      locations = {
        "= /.well-known/matrix/server".extraConfig = mkWellKnown serverConfig;
        "= /.well-known/matrix/client".extraConfig = mkWellKnown clientConfig;
      };
    };
    "${fqdn}" = {
      locations = {
        "/".extraConfig = ''
          return 404;
        '';
        "/_matrix".proxyPass = "http://127.0.0.1:8008";
        "._synapse/client".proxyPass = "http://127.0.0.1:8008";
      };
    };
    "element.leftrmodule.com" = {
      serverAliases = [
        "element.${fqdn}"
      ];
      root = pkgs.element-web.override {
        conf.default_server_config = clientConfig;
      };
      locations."/".extraConfig = ''
        add_header Cache-Control "no-cache";
      '';
      extraConfig = ''
        add_header X-Frame-Options SAMEORIGIN;
        add_header X-Content-Type-Options nosniff;
        add_header X-XSS-Protection "1; mode=block";
        add_header Content-Security-Policy "frame-ancestors 'none'";
      '';
    };
  };
}
