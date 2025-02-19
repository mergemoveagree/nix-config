{ lib
, pkgs
, ...
}: {
  imports = lib.custom.scanPaths ./.;

  home.packages = with pkgs; [
    wl-clipboard-rs
    seahorse
  ];
}
