{ pkgs
, ...
}:
{
  programs.thunar.enable = true;
  programs.thunar.plugins = with pkgs.xfce; [
    thunar-archive-plugin
    thunar-volman
  ];
  # Needed to save prefs if not using xfce
  programs.xfconf.enable = true;
}
