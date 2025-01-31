{ lib
, ...
}: {
  boot.loader.systemd-boot.enable = lib.mkDefault true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/efi";
  boot.initrd.systemd.enable = lib.mkDefault true;
}
