{ lib
, ...
}: {
  imports = lib.flatten [
    (map lib.custom.relativeToRoot [
      "home/common/core"
      "home/common/features/desktop"
      "home/common/features/media.nix"
      "home/common/features/comms.nix"
      "home/common/features/office.nix"
    ])

    ./global
    ./features/comms.nix
    ./features/thunderbird.nix
  ];

  services.easyeffects.preset = "Loudness+Autogain";
  wayland.windowManager.hyprland.settings.input.touchpad.clickfinger_behavior = true;
}
