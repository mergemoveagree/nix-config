
{ inputs
, pkgs
, lib
, config
, ...
}: {
  sops.secrets = {
    "elmo_password" = {
      neededForUsers = true;
      sopsFile = lib.custom.relativeToRoot "home/secrets.yml";
    };
  };

  users.users.elmo = {
    name = "elmo";
    isNormalUser = true;
    extraGroups = [ "networkmanager" "input" ] ++ lib.optional config.hostSpec.doGaming "gamemode";
    hashedPasswordFile = config.sops.secrets."elmo_password".path;
  } // lib.optionalAttrs config.hostSpec.enableZsh {
    shell = pkgs.zsh;
  };

  programs.zsh.enable = config.hostSpec.enableZsh;

  environment.systemPackages = with pkgs; [
    just
  ];

}
// lib.optionalAttrs (inputs ? "home-manager") {
  home-manager.users.elmo = import (lib.custom.relativeToRoot "home/elmo/${config.hostSpec.hostName}.nix");
}
