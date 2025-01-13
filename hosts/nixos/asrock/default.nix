{
  imports = [
    ../../common/core

    ../../common/features/sops.nix
    ../../common/features/home-manager.nix
  ];

  networking.hostName = "asrock";
}
