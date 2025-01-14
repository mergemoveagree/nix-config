{ lib
, pkgs
, ...
}: {
  imports = (map lib.custom.relativeToRoot [
    "home/common/core"
    "home/common/features/desktop"
    "home/common/features/gaming"
  ]);

  home.packages = [ pkgs.nixvim-neovim ];
  services.easyeffects.preset = "Perfect EQ";
}
