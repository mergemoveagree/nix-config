{ lib
, inputs
, ...
}: let
  relRoot = lib.custom.relativeToRoot;
in {
  imports = lib.flatten [
    inputs.hardware.nixosModules.common-cpu-intel-cpu-only
    inputs.hardware.nixosModules.common-gpu-amd

    (map lib.custom.relativeToRoot [
      "hosts/common/core"
      
      "hosts/common/users/user"

      "hosts/common/features/mullvad-vpn.nix"
      "hosts/common/features/hyprland.nix"
      "hosts/common/features/gaming"
      "hosts/common/features/monero.nix"
    ])
  ];

  hostSpec = {
    hostName = "asrock";
    netInterface = "enp6s0";
    monitors = [
      {
        portName = "DP-1";
        width = 3440;
        height = 1440;
        refreshRate = 160;
        wallpaper = relRoot "wallpapers/stray.png";
        lockscreen = relRoot "wallpapers/stray1.png"; 
        primary = true;
      }
      {
        portName = "DP-2";
        width = 2560;
        height = 1440;
        refreshRate = 144;
        alignOffsetX = -1920;
        alignOffsetY = 360;
        wallpaper = relRoot "wallpapers/terraria.jpg";
        lockscreen = relRoot "wallpapers/skyrim.jpg"; 
      }
    ];
    enableZsh = true;
    doGaming = true;
    gamemodeSettings = {
      gpu_device = 1;
      amd_performance_level = "auto";
    };
  };
}
