{ inputs
, pkgs
, lib
, config
, ...
}: {
  sops.secrets = {
    "user_password" = {
      neededForUsers = true;
      sopsFile = lib.custom.relativeToRoot "home/user/secrets.yml";
    };
  };

  users.users.user = {
    name = "user";
    isNormalUser = true;
    extraGroups = [ "networkmanager" "input" ];
    hashedPasswordFile = config.sops.secrets."user_password".path;
  } // lib.optionalAttrs config.hostSpec.enableZsh {
    shell = pkgs.zsh;
  };

  programs.zsh.enable = config.hostSpec.enableZsh;

}
// lib.optionalAttrs (inputs ? "home-manager") {
  home-manager.users.user = import (lib.custom.relativeToRoot "home/user/${config.hostSpec.hostName}.nix");
}
