{ lib
, ...
}: {
  imports = (map lib.custom.relativeToRoot [
    "home/common/core"
    "home/common/features/desktop"
    "home/common/features/gaming"
    "home/common/features/media.nix"
    "home/common/features/comms.nix"
    "home/common/features/office.nix"

    "home/user/features/comms.nix"
  ]);

  services.easyeffects.preset = "Perfect EQ";
}
