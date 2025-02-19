{ config
, pkgs
, ...
}: let
  main = "leftrmodule.com";
  fqdn = "matrix.${main}";
  baseUrl = "https://${fqdn}";
in {
  imports = [
    ./postgresql.nix
  ];

  sops.secrets."matrix-synapse_extra_config" = {
    owner = "matrix-synapse";
    sopsFile = ../secrets.yml;
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
      proxy_read_timeout 60s;
      proxy_headers_hash_max_size 512;
      proxy_headers_hash_bucket_size 128;
    '';
  in {
      ${main} = {
        forceSSL = true;
        useACMEHost = "leftrmodule.com-main";
        locations = {
          "= /.well-known/matrix/server" = mkWellKnown serverConfig;
          "= /.well-known/matrix/client" = mkWellKnown clientConfig;
        };
      };
      ${fqdn} = {
        forceSSL = true;
        useACMEHost = "leftrmodule.com";
        locations = {
          "/".extraConfig = ''
            return 404;
          '';
          "~ ^(/_matrix|/_synapse/client)" = {
            proxyPass = "http://127.0.0.1:8008";
            extraConfig = ''
              ${extraConfig}
              proxy_http_version 1.1;
              client_max_body_size 50M;
            '';
          };
        };
      };
    "element.${main}" = let
      recommendedCfg = ''
        add_header X-Frame-Options SAMEORIGIN;
        add_header X-Content-Type-Options nosniff;
        add_header X-XSS-Protection "1; mode=block";
        add_header Content-Security-Policy "frame-ancestors 'none'";
      '';
    in {
      forceSSL = true;
      useACMEHost = "leftrmodule.com";
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

  services.matrix-synapse = {
    enable = true;
    settings = {
      server_name = main;
      public_baseurl = baseUrl;
      listeners = [
        {
          bind_addresses = [ "127.0.0.1" ];
          port = 8008;
          type = "http";
          tls = false;
          x_forwarded = true;
          resources = [
            {
              names = [ "client" "federation" ];
              compress = true;
            }
          ];
        }
      ];
    };
    extraConfigFiles = [
      config.sops.secrets."matrix-synapse_extra_config".path
    ];
  };
}
