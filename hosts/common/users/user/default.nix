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
    shell = pkgs.zsh;
  };

  programs.zsh.enable = config.hostSpec.enableZsh;

}
// lib.optionalAttrs (inputs ? "home-manager") {
  home-manager.users.${config.hostSpec.username} = import (lib.custom.relativeToRoot "home/user/${config.hostSpec.hostName}.nix");
}
