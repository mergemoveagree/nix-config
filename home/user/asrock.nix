{ lib
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
    ./features/comms.nix
    ./features/thunderbird.nix
  ];

  services.easyeffects.preset = "Perfect EQ";
}
