{ lib
, pkgs
, ...
}: {
  imports = lib.custom.scanPaths ./.;

  home.packages = with pkgs; [
    #mullvad-browser
    wl-clipboard-rs
    seahorse
  ];
}
