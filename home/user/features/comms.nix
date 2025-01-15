{ pkgs
, ...
}: {
  home.packages = with pkgs; [
    fractal
    vesktop
  ];
}
