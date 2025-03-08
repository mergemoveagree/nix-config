{ config
, ...
}: {
  sops.secrets = {
    "admin_password" = {
      neededForUsers = true;
      sopsFile = ../secrets.yml;
    };
  };

  users.users.admin = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    hashedPasswordFile = config.sops.secrets."admin_password".path;
  };
}
