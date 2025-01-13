{ inputs
, pkgs
, lib
, config
, ...
}: {
  sops.secrets = {
    "user_password_${config.hostSpec.hostName}" = {
      neededForUsers = true;
      sopsFile = lib.custom.relativeToRoot "home/user/secrets.yml";
    };
  };

  users.users.${config.hostSpec.username} = {
    name = config.hostSpec.username;
    isNormalUser = true;
    extraGroups = [ "networkmanager" "input" ];
    hashedPasswordFile = config.sops.secrets."user_password_${config.hostSpec.hostName}".path;
  } // lib.optionalAttrs config.hostSpec.enableZsh {
    programs.zsh.enable = true;
    shell = pkgs.zsh;
  };
}
// lib.optionalAttrs (inputs ? "home-manager") {
  home-manager.users.${config.hostSpec.username} = import (lib.relativeToRoot "home/user/${config.hostSpec.hostName}.nix");
}
