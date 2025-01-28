{ lib
, inputs
, pkgs
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
      
      "hosts/common/features/sops.nix"
      "hosts/common/features/home-manager.nix"
      "hosts/common/features/secure-boot.nix"
      "hosts/common/features/mullvad-vpn.nix"
      "hosts/common/features/hyprland.nix"
      "hosts/common/features/gaming"
      "hosts/common/features/monero.nix"
      "hosts/common/features/opencl.nix"
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
        hdr = true;
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

  networking = {
    interfaces.enp6s0 = {
      ipv4.addresses = [{
        address = "192.168.1.5";
        prefixLength = 24;
      }];
    };
    defaultGateway = {
      address = "192.168.1.254";
      interface = "enp6s0";
    };
  };

  environment.systemPackages = with pkgs; [
    lact
  ];

  systemd.packages = with pkgs; [ lact ];
  systemd.services.lactd = {
    enable = true;
    wantedBy = ["multi-user.target"];
  };

  boot.kernelParams = [
    "amdgpu.ppfeaturemask=0xfff7ffff"
  ];
}
