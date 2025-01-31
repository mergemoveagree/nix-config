{ pkgs
, ...
}: {
  home.packages = [
    (pkgs.heroic.override {
      extraPkgs = heroic-pkgs: [
        heroic-pkgs.gamescope
      ];
    })
  ];
}
