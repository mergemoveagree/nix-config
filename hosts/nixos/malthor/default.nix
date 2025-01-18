{ config
, inputs
, lib
, ...
}:
{
  imports = lib.flatten [
    inputs.hardware.nixosModules.common-pc-laptop
    inputs.hardware.nixosModules.common-pc-laptop-hdd
    inputs.hardware.nixosModules.common-cpu-intel
    inputs.hardware.nixosModules.common-gpu-nvidia
    (map lib.custom.relativeToRoot [
      "hosts/common/core"

      "hosts/common/users/elmo"

      "hosts/common/features/hyprland.nix"
      "hosts/common/features/gaming"
    ])
  ];

  hostSpec = {
    hostName = "malthor";
    netInterface = "wlan0";
    monitors = [
      {
        portName = "eDP-1";
        width = 1920;
        height = 1080;
        wallpaper = lib.custom.relativeToRoot "wallpapers/er2.png";
        lockscreen = lib.custom.relativeToRoot "wallpapers/er1.png";
        primary = true;
      }
    ];
    enableZsh = true;
    doGaming = true;
  };

  boot.extraModprobeConfig = ''
    install uvcvideo /bin/false
  '';

  hardware.enableRedistributableFirmware = true;

  # NVIDIA Setup
  allowedUnfree = [
    "discord"
    "nvidia-x11"
    "nvidia-settings"
    "nvidia-persistenced"
  ];

  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    prime = {
      reverseSync.enable = true;
      allowExternalGpu = true;
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
}
