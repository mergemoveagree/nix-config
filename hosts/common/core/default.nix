{ lib
, outputs
, pkgs
, config
, ...
}: {
  imports = lib.custom.scanPaths ./.
  ++ lib.flatten [
    (map lib.custom.relativeToRoot [
      "modules/core"
      "hosts/common/users/admin"
    ])
  ];

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;
    warn-dirty = false;
  };

  nixpkgs.overlays = [
    outputs.overlays.default
  ];

  networking.hostName = config.hostSpec.hostName;

  boot.loader.systemd-boot.enable = lib.mkDefault true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/efi";
  boot.initrd.systemd.enable = lib.mkDefault true;

  users.mutableUsers = false;
  users.users.root.hashedPassword = "!";

  # Enabling smart card support
  services.udev.packages = [ pkgs.yubikey-personalization ];
  services.pcscd.enable = true;

  system.stateVersion = "24.05";
}
