{ pkgs
, ...
}: {
  home.packages = with pkgs; [
    mullvad-browser
    tor-browser
  ];
}
