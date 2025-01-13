{ lib
, pkgs
, ...
}: {
  imports = (map lib.custom.relativeToRoot [
    "home/common/core"
  ]);

  home.packages = [ pkgs.nixvim-neovim ];
}
