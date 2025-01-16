{ config
, ...
}: {
  sops.secrets."ssh_user_teemo_access_private_key".sopsFile = ../secrets.yml;

  programs.ssh = {
    enable = true;
    matchBlocks = {
      "teemo" = {
        hostname = "192.168.1.3";
        identitiesOnly = true;
        identityFile = config.sops.secrets."ssh_user_teemo_access_private_key".path;
        user = "user";
      };
    };
  };
}

