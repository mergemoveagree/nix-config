{ pkgs
, ...
}: {
  home.packages = with pkgs; [
    prismlauncher
    r2modman
    openrgb  # TODO: Move somewhere that makes sense
  ];
}
