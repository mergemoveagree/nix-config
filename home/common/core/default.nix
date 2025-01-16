{ pkgs
, lib
, hostSpec
, ...
}: {
  imports = lib.custom.scanPaths ./. 
  ++ lib.flatten [
    (map lib.custom.relativeToRoot [
      "modules/core/host-spec.nix"
    ])
  ];

  inherit hostSpec;

  home.packages = with pkgs; [
    wl-clipboard-rs
  ];
  
  programs.home-manager.enable = true;
  home.stateVersion = "24.05";
}
