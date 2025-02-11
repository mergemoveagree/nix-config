{ config
, ...
}: {
  imports = [
    ./nginx.nix
    ./postgresql.nix
  ];

  sops.secrets."matrix-synapse_extra_config" = {
    owner = "matrix-synapse";
    sopsFile = ../secrets.yml;
  };

  services.matrix-synapse = {
    enable = true;
    settings = {
      server_name = "leftrmodule.com";
      public_baseurl = "https://matrix.leftrmodule.com";
      listeners = [
        {
          port = 8008;
          bind_addresses = [ "127.0.0.1" ];
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
