{ inputs
, pkgs
, config
, lib
, ...
}: let
  hyprland-pkgs = inputs.hyprland.packages.${pkgs.system};
  hyprland-nixpkgs = inputs.hyprland.inputs.nixpkgs.legacyPackages.${pkgs.system};
in {
  nix.settings = {
    substituters = ["https://hyprland.cachix.org"];
    trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = config.hostSpec.doGaming;
  };

  programs.hyprland = {
    enable = true;
    package = hyprland-pkgs.hyprland;
    portalPackage = hyprland-pkgs.xdg-desktop-portal-hyprland;
  };

  # Since this config is on nixpkgs-unstable, this shouldn't be needed, but just in case...
  system.replaceDependencies.replacements = [
    { oldDependency = pkgs.mesa; newDependency = hyprland-nixpkgs.mesa; }
  ] ++
  lib.optionals config.hostSpec.doGaming [
    { oldDependency = inputs.nixpkgs.legacyPackages.${pkgs.system}.pkgsi686Linux.mesa; newDependency = hyprland-nixpkgs.pkgsi686Linux.mesa; }
  ];

  environment.systemPackages = [ pkgs.kitty ];
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # Setting up keyring for secrets
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.hyprland-gnome-keyring.enableGnomeKeyring = true;
}
