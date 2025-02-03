{ config
, ...
}: {
  sops.secrets."ssh_user_nixos_provision_key".sopsFile = {
    path = "${config.home.homeDirectory}/.ssh/nixos_provision";
    sopsFile = ../secrets.yml;
  };
}
