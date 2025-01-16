{ pkgs
, config
, ...
}: {
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
