{ pkgs
, lib
, ...
}: {
  imports = lib.flatten [
    (map lib.custom.relativeToRoot [
      "home/common/core"
      "home/common/features/desktop"
      "home/common/features/media.nix"
      "home/common/features/comms.nix"
      "home/common/features/office.nix"
      "home/common/features/headset.nix"
    ])
  ];

  home.packages = with pkgs; [
    discord
  ];

  services.easyeffects.preset = "Loudness+Autogain";
}
