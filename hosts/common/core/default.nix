{ lib
, outputs
, ...
}: {
  imports = lib.flatten [
    (map lib.custom.relativeToRoot [
      "modules/core"
      "hosts/common/users/user"
      "hosts/common/users/admin"
    ])
    ./linux-hardening
    ./chrony.nix
    ./networking.nix
    ./openssh.nix
    ./pipewire.nix
    ./sops.nix
    ./thunar.nix
  ];

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;
    warn-dirty = false;
  };

  nixpkgs.overlays = [
    outputs.overlays.default
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/efi";
  boot.initrd.systemd.enable = true;

  users.mutableUsers = false;
  users.users.root.hashedPassword = "!";

  system.stateVersion = "24.05";
}
