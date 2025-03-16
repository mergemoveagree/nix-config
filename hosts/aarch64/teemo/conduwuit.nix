{ config
, pkgs
, ...
}: let
  unix_socket_path = "/run/conduwuit/conduwuit.sock";
  server_name = "leftrmodule.com";
  fqdn = "matrix.${server_name}";
  baseUrl = "https://${fqdn}";
in {
  sops.secrets."conduwuit_registration_token" = {
    owner = "conduwuit";
    group = "nginx";
    mode = "0660";
    sopsFile = ./secrets.yml;
  };

  services.nginx.virtualHosts = let
    clientConfig."m.homeserver".base_url = baseUrl;
    serverConfig."m.server" = "${fqdn}:443";
    mkWellKnown = data: {
      return = "200 '${builtins.toJSON data}'";
      extraConfig = ''
        default_type application/json;
        add_header Access-Control-Allow-Origin *;
      '';
    };
    extraConfig = ''
      proxy_pass_request_headers on;
      proxy_headers_hash_max_size 512;
      proxy_headers_hash_bucket_size 128;
    '';
  in {
      ${server_name} = {
        forceSSL = true;
        useACMEHost = "leftrmodule.com";
        locations = {
          "= /.well-known/matrix/server" = mkWellKnown serverConfig;
          "= /.well-known/matrix/client" = mkWellKnown clientConfig;
        };
      };
      ${fqdn} = {
        forceSSL = true;
        useACMEHost = "leftrmodule.com-wildcard";
        locations = {
          "/".extraConfig = ''
            return 404;
          '';
          "~ ^(/_matrix|/_synapse/client)" = {
            proxyPass = "http://unix:${unix_socket_path}";
            extraConfig = ''
              ${extraConfig}
              proxy_http_version 1.1;
              client_max_body_size 20M;
            '';
          };
        };
      };
    "element.${server_name}" = let
      recommendedCfg = ''
        add_header X-Frame-Options SAMEORIGIN;
        add_header X-Content-Type-Options nosniff;
        add_header X-XSS-Protection "1; mode=block";
        add_header Content-Security-Policy "frame-ancestors 'none'";
      '';
    in {
      forceSSL = true;
      useACMEHost = "leftrmodule.com-wildcard";
      serverAliases = [ "element.${fqdn}" ];
      locations."/".extraConfig = ''
        ${recommendedCfg}
        add_header Cache-Control "no-cache";
      '';
      root = pkgs.element-web.override {
        conf.default_server_config = { "m.homeserver".base_url = baseUrl; };
      };
      extraConfig = recommendedCfg;
    };
  };

  services.conduwuit = {
    enable = true;
    group = "nginx";
    settings = {
      global = {
        inherit 
          server_name
          unix_socket_path
        ;
        address = null;
        port = [ ];
        new_user_displayname_suffix = "💡";
        ip_lookup_strategy = 1;
        allow_registration = true;
        registration_token_file = config.sops.secrets."conduwuit_registration_token".path;
        lockdown_public_room_directory = true;
        allow_room_creation = false;
      };
    };
  };
}
