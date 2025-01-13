{ pkgs
, ...
}: {
  home.packages = with pkgs; [
    wl-clipboard-rs
  ];
  
  programs.home-manager.enable = true;
  home.stateVersion = "24.05";
}
