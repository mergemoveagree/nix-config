{ pkgs
, ...
}: let
  rofi-themes-collection = pkgs.fetchFromGitHub {
    owner = "newmanls";
    repo = "rofi-themes-collection";
    rev = "c2be059e9507785d42fc2077a4c3bc2533760939";
    hash = "sha256-pHPhqbRFNhs1Se2x/EhVe8Ggegt7/r9UZRocHlIUZKY=";
  };
in {
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    theme = "${rofi-themes-collection}/themes/simple-tokyonight.rasi";
  };
}
