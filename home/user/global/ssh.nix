{ config
, ...
}: {
  sops.secrets = {
    "ssh_user_teemo_access_private_key".sopsFile = ../secrets.yml;
    "ssh_user_teemo_update_private_key".sopsFile = ../secrets.yml;
    "ssh_user_hyeonseong_access_private_key".sopsFile = ../secrets.yml;
    "ssh_user_hyeonseong_update_private_key".sopsFile = ../secrets.yml;
  };

  programs.ssh = {
    enable = true;
    matchBlocks = {
      "teemo" = {
        hostname = "10.100.0.2";
        identitiesOnly = true;
        identityFile = config.sops.secrets."ssh_user_teemo_access_private_key".path;
        user = "user";
      };

      "teemo-unlock" = {
        hostname = "192.168.1.3";
        #hostname = "10.100.0.5";
        identitiesOnly = true;
        identityFile = config.sops.secrets."ssh_user_teemo_access_private_key".path;
        user = "root";
        port = 2222;
      };

      "teemo-update" = {
        hostname = "10.100.0.2";
        identitiesOnly = true;
        identityFile = config.sops.secrets."ssh_user_teemo_update_private_key".path;
        user = "root";
      };

      "hyeonseong" = {
        hostname = "10.100.0.1";
        identitiesOnly = true;
        identityFile = config.sops.secrets."ssh_user_hyeonseong_access_private_key".path;
        user = "user";
      };

      "hyeonseong-update" = {
        hostname = "10.100.0.1";
        identitiesOnly = true;
        identityFile = config.sops.secrets."ssh_user_hyeonseong_update_private_key".path;
        user = "root";
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

