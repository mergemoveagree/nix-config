{ inputs
, pkgs
, config
, lib
, ...
}: let
  hyprland-pkgs = inputs.hyprland.packages.${pkgs.system};
  hyprland-nixpkgs = inputs.hyprland.inputs.nixpkgs.legacyPackages.${pkgs.system};
in {
  imports = lib.custom.scanPaths ./.;

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
    withUWSM = true;
  };

  # Since this config is on nixpkgs-unstable, this shouldn't be needed, but just in case...
  system.replaceDependencies.replacements = let
    hyprlandMesa = hyprland-nixpkgs.mesa;
    hyprlandMesa32 = hyprland-nixpkgs.pkgsi686Linux.mesa;
    nixpkgsMesa32 = inputs.nixpkgs.legacyPackages.${pkgs.system}.pkgsi686Linux.mesa;
  in 
  lib.optional (pkgs.mesa != hyprlandMesa) { oldDependency = pkgs.mesa; newDependency = hyprlandMesa; }
  ++ lib.optional (config.hostSpec.doGaming && nixpkgsMesa32 != hyprlandMesa32) { oldDependency = nixpkgsMesa32; newDependency = hyprlandMesa32; };

  environment.systemPackages = [ pkgs.kitty ];
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # Setting up keyring for secrets
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.hyprland-gnome-keyring.enableGnomeKeyring = true;
}
