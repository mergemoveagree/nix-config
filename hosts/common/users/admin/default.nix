{ config
, lib
, ...
}: {
  sops.secrets = {
    "admin_password" = {
      neededForUsers = true;
      sopsFile = lib.custom.relativeToRoot "home/secrets.yml";
    };
  };

  users.users.admin = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    hashedPasswordFile = config.sops.secrets."admin_password".path;
  };
}
