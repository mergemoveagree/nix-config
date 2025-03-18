{ lib
, pkgs
, config
, ...
}: {
  imports = lib.flatten [
    (map lib.custom.relativeToRoot [
      "home/common/core"
      "home/common/features/desktop"
      "home/common/features/gaming"
      "home/common/features/media.nix"
      "home/common/features/comms.nix"
      "home/common/features/office.nix"
    ])

    ./global
    ./features/apps.nix
    ./features/comms.nix
    ./features/heroic.nix
    ./features/mail-client.nix
  ];

  home.packages = with pkgs; [
    monero-gui
    eddie
  ];

  services.easyeffects.preset = "Perfect EQ";

  programs.ssh.matchBlocks = {
    "teemo-vps" = {
      hostname = "10.100.0.2";
      identitiesOnly = true;
      identityFile = config.sops.secrets."ssh_user_teemo_access_private_key".path;
      user = "user";
      port = 2223;
    };
  };
}
