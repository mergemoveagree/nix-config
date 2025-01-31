{ pkgs
, ...
}: {
  # Enabling smart card support
  services.udev.packages = [ pkgs.yubikey-personalization ];
  services.pcscd.enable = true;

}
