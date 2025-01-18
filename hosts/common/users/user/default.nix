{ inputs
, pkgs
, lib
, config
, ...
}: {
  sops.secrets = {
    "user_password" = {
      neededForUsers = true;
      sopsFile = lib.custom.relativeToRoot "home/secrets.yml";
    };
  };

  users.users.user = {
    name = "user";
    isNormalUser = true;
    extraGroups = [ "networkmanager" "input" ] ++ lib.optional config.hostSpec.doGaming "gamemode";
    hashedPasswordFile = config.sops.secrets."user_password".path;
  } // lib.optionalAttrs config.hostSpec.enableZsh {
    shell = pkgs.zsh;
  };

  programs.zsh.enable = config.hostSpec.enableZsh;

  environment.systemPackages = with pkgs; [
    just
  ];

}
// lib.optionalAttrs (inputs ? "home-manager") {
  home-manager.users.user = import (lib.custom.relativeToRoot "home/user/${config.hostSpec.hostName}.nix");
}
