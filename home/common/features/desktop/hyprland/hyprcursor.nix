{ pkgs
, ...
}: let
  nordzy-cursor-theme = pkgs.fetchFromGitHub {
    owner = "guillaumeboehm";
    repo = "Nordzy-cursors";
    rev = "v2.3.0";
    hash = "sha256-3HUSl0CQcay4V9pO35cmOEZvrgNOJ3WNZahs+hJjUJU=";
  };
in {
  home.packages = [ pkgs.hyprcursor ];
  # TODO: Supply cursor theme via home.pointerCursor
  xdg.dataFile."icons/Nordzy-cursors" = {
    source = "${nordzy-cursor-theme}/hyprcursors/themes/Nordzy-hyprcursors";
    recursive = true;
  };
  wayland.windowManager.hyprland.settings.env = [
    "HYPRCURSOR_THEME,Nordzy-cursors"
    "HYPRCURSOR_SIZE,24"
  ];
}
