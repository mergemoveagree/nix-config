{ config
, ...
}: {
  imports = [
    ./nginx.nix
    ./postgresql.nix
  ];

  sops.secrets."matrix-synapse_extra_config".sopsFile = ../secrets.yml;

  services.matrix-synapse = {
    enable = true;
    settings = {
      server_name = "matrix.leftrmodule.com";
      public_baseurl = "https://matrix.leftrmodule.com";
      listeners = [
        {
          port = 8008;
          bind_addresses = [ "::1" ];
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
