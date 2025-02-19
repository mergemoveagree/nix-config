{ config
, pkgs
, ...
}: {
  imports = [
    ./postgresql.nix
  ];

  sops.secrets."matrix-synapse_extra_config" = {
    owner = "matrix-synapse";
    sopsFile = ../secrets.yml;
  };

  services.nginx.virtualHosts = let
    extraConfig = ''
      proxy_pass_request_headers on;
      proxy_read_timeout 180;
      proxy_headers_hash_max_size 512;
      proxy_headers_hash_bucket_size 128;
    '';
  in {
    "element.leftrmodule.com" = {
      rejectSSL = true;
      serverAliases = [ "element.matrix.leftrmodule.com" ];
      root = pkgs.element-web.override {
        conf.default_server_config = { "m.homeserver".base_url = "https://matrix.leftrmodule.com"; };
      };
      inherit extraConfig;
    };
  };

  services.matrix-synapse = {
    enable = true;
    settings = {
      server_name = "leftrmodule.com";
      public_baseurl = "https://matrix.leftrmodule.com";
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
