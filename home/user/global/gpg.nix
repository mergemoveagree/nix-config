{ pkgs
, config
, ...
}: {
  services.udev.packages = [ pkgs.yubikey-personalization ];
  services.pcscd.enable = true;

  programs.gpg = {
    enable = true;
    mutableKeys = true;
    mutableTrust = false;
    publicKeys = [
      {
        source = ./pgp.asc;
        trust = 5;
      }
    ];
  };

  services.gpg-agent = {
    enable = true;
    enableZshIntegration = config.hostSpec.enableZsh;
    enableScDaemon = true;
    pinentryPackage = pkgs.pinentry-qt;
  };
}
