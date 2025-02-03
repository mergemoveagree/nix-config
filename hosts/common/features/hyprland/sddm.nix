{ pkgs
, ...
}: {
  environment.systemPackages = with pkgs; [
    ((sddm-astronaut.override {
      # Changing deafault SDDM theme
      themeConfig = {
        ConfigFile = "Themes/pixel_sakura.conf";
      };
    }).overrideAttrs ({ installPhase ? "", ... }: {
      # Moving fonts to correct directory
      installPhase = installPhase + ''
        mkdir -p $out/share/fonts
        cp -r $out/share/sddm/themes/sddm-astronaut-theme/Fonts/* $out/share/fonts/
        sed -i 's?ConfigFile=.*?ConfigFile=Themes/pixel_sakura.conf?' $out/share/sddm/themes/sddm-astronaut-theme/metadata.desktop
      '';
    }))
  ];

  services.displayManager = {
    defaultSession = "hyprland-uwsm";
    sddm = {
      enable = true;
      wayland.enable = true;
      package = pkgs.kdePackages.sddm;
      extraPackages = with pkgs.kdePackages; [
        qtmultimedia
      ];
      theme = "sddm-astronaut-theme";
      settings = {
        General = {
          InputMethod = "qtvirtualkeyboard";
        };
      };
    };
  };
}
