{ config
, lib
, pkgs
, inputs
, ...
}: {
  programs.zsh.enable = config.hostSpec.enableZsh;
  users.mutableUsers = false;

  sops.secrets = lib.mkIf (inputs ? "sops-nix") (lib.foldlAttrs (_: name: { sopsFile, ... }: {
    "${name}_password" = {
      inherit sopsFile;
      neededForUsers = true;
    };
  }) {} config.userSpec);

  users.users = (
    lib.foldlAttrs (_: name: _: {
      ${name} = {
        inherit name;
        isNormalUser = true;
        extraGroups = [ "networkmanager" "input" ] ++ lib.optional config.hostSpec.doGaming "gamemode";
        hashedPasswordFile = config.sops.secrets."${name}_password".path;
      }
      // lib.optionalAttrs config.hostSpec.enableZsh {
        shell = pkgs.zsh;
      };
    }) {} config.userSpec
  )
  // {
      root.hashedPassword = "!";
  };

  environment.systemPackages = with pkgs; [
    just
  ];
}
