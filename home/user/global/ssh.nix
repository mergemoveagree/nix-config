{ config
, ...
}: {
  sops.secrets = {
    "ssh_user_teemo_access_private_key".sopsFile = ../secrets.yml;
    "ssh_user_hyeonseong_access_private_key".sopsFile = ../secrets.yml;
  };

  programs.ssh = {
    enable = true;
    matchBlocks = {
      "teemo" = {
        hostname = "192.168.1.3";
        identitiesOnly = true;
        identityFile = config.sops.secrets."ssh_user_teemo_access_private_key".path;
        user = "user";
      };

      "teemo-unlock" = {
        hostname = "192.168.1.3";
        identitiesOnly = true;
        identityFile = config.sops.secrets."ssh_user_teemo_access_private_key".path;
        user = "root";
        port = 2222;
      };

      "hyeonseong" = {
        hostname = "185.141.216.3";
        identitiesOnly = true;
        identityFile = config.sops.secrets."ssh_user_hyeonseong_access_private_key".path;
        user = "user";
      };

      "gh-mma" = {
        hostname = "github.com";
        user = "git";
        identitiesOnly = true;
        identityFile = config.sops.secrets."ssh_github_private_key".path;
      };
    };
  };
}

