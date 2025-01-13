{ lib
, config
, ...
}: {
  imports = lib.custom.scanPaths ./.;

  programs.kitty = {
    enable = true;
    enableZshIntegration = config.hostSpec.enableZsh;
    enableBashIntegration = !config.hostSpec.enableZsh;
  };

  wayland.windowManager.hyprland.enable = true;
  wayland.windowManager.hyprland.systemd.enable = true;
  wayland.windowManager.hyprland.xwayland.enable = true;
}
