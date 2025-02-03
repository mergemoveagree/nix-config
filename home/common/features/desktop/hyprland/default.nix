{ lib
, config
, pkgs
, inputs
, ...
}: {
  imports = lib.custom.scanPaths ./.;

  programs.kitty = {
    enable = true;
    shellIntegration = {
      enableZshIntegration = config.hostSpec.enableZsh;
      enableBashIntegration = !config.hostSpec.enableZsh;
    };
  };

  services.swaync.enable = true;

  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    # Set to false for UWSM integration
    systemd.enable = false;
    xwayland.enable = true;
  };

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
