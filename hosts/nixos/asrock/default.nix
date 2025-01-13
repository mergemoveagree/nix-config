{ lib
, ...
}: let
  relRoot = lib.custom.relativeToRoot;
in {
  imports = (map lib.custom.relativeToRoot [
    "hosts/common/core"
    "hosts/common/features/home-manager.nix"
    "hosts/common/features/mullvad-vpn.nix"
  ]);

  hostSpec = {
    hostName = "asrock";
    netInterface = "wlan0";
    monitors = [
      {
        portName = "DP-1";
        width = 3440;
        height = 1440;
        refreshRate = 160;
        wallpaper = relRoot "wallpapers/sl.jpg";
        lockscreen = relRoot "wallpapers/hsr2.jpg"; 
      }
      {
        portName = "DP-2";
        width = 2560;
        height = 1440;
        refreshRate = 144;
        alignOffsetX = -1920;
        alignOffsetY = 360;
        wallpaper = relRoot "wallpapers/rags.jpg";
        lockscreen = relRoot "wallpapers/hsr.jpg"; 
      }
    ];
    doGaming = true;
    gamemodeSettings = {
      gpu_device = 1;
      amd_performance_level = "auto";
    };
  };
}
