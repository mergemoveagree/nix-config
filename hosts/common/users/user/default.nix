{ inputs
, pkgs
, lib
, config
, ...
}: {
  sops.secrets = {
    "user_password" = {
      neededForUsers = true;
      sopsFile = ../../../../home/user/secrets.yml;
    };
  };

  users.users."user" = {
    name = "user";
    isNormalUser = true;
    extraGroups = [ "networkmanager" "input" ];
    hashedPasswordFile = config.sops.secrets."user_password".path;
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;
}
// lib.optionalAttrs (inputs ? "home-manager") {
  home-manager.users."user" = import ../../../home/user/${config.networking.hostName}.nix;
}
