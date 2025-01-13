{ inputs
, pkgs
, lib
, config
, ...
}: {
  hostSpec.username = "user";

  sops.secrets = {
    "user_password" = {
      neededForUsers = true;
      sopsFile = lib.custom.relativeToRoot "home/user/secrets.yml";
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
  home-manager.users."user" = import (lib.relativeToRoot "home/${config.hostSpec.username}/${config.hostSpec.hostName}.nix");
}
