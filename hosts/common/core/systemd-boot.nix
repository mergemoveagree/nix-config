{ lib
, ...
}: {
  boot.loader.systemd-boot.enable = lib.mkDefault true;
  boot.loader.efi.canTouchEfiVariables = lib.mkDefault true;
  boot.loader.efi.efiSysMountPoint = lib.mkDefault "/efi";
  boot.initrd.systemd.enable = lib.mkDefault true;
}
