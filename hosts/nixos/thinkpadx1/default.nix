{ inputs
, lib
, pkgs
, ...
}: {
  imports = lib.flatten [
    inputs.hardware.nixosModules.lenovo-thinkpad-x1-9th-gen
    inputs.hardware.nixosModules.common-pc-laptop
    inputs.hardware.nixosModules.common-pc-laptop-ssd
    inputs.hardware.nixosModules.common-cpu-intel

    (map lib.custom.relativeToRoot [
      "hosts/common/core"
      
      "hosts/common/users/user"

      "hosts/common/features/sops.nix"
      "hosts/common/features/home-manager.nix"
      "hosts/common/features/mullvad-vpn.nix"
      "hosts/common/features/hyprland.nix"
    ])

    ./hardware-configuration.nix
  ];

  hostSpec = {
    hostName = "thinkpadx1";
    netInterface = "wlan0";
    monitors = [
      {
        portName = "eDP-1";
        width = 1920;
        height = 1200;
        refreshRate = 60;
        wallpaper = lib.custom.relativeToRoot "wallpapers/orv.png";
        lockscreen = lib.custom.relativeToRoot "wallpapers/orv1.png"; 
        primary = true;
      }
    ];
    enableZsh = true;
  };

  hardware.graphics.extraPackages = with pkgs; [
    intel-media-driver
    libvdpau-va-gl
  ];

  hardware.firmware = [ pkgs.sof-firmware ];

  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "iHD";
  };
}
