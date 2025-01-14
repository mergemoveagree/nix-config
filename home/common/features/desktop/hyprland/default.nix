{ lib
, config
, pkgs
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

  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    kdePackages.ark
    kdePackages.okular
    pavucontrol
    xwaylandvideobridge

    nerd-fonts.space-mono
    font-awesome
  ];
}
