{ config
, ...
}: {
  services.hyprpaper.enable = true;
  services.hyprpaper.settings = {
    preload = map (monitor: "${monitor.wallpaper}") config.hostSpec.monitors;
    wallpaper = map (monitor: with monitor; "${portName},${wallpaper}") config.hostSpec.monitors;
  };
}
