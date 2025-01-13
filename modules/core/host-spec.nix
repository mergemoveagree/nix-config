{ lib
, ...
}: with lib; {
  options.hostSpec = let
    monitor = submodule {
      options = {
        portName = mkOption {
          type = types.str;
          description = "The name of the port used by the monitor";
          example = "DP-1";
        };
        height = mkOption {
          type = types.int.positive;
          description = "The height of the monitor";
          example = 1440;
        };
        width = mkOption {
          type = types.int.positive;
          description = "The width of the monitor";
          example = 2560;
        };
        refreshRate = mkOption {
          type = types.int.positive;
          description = "The refresh rate of the monitor in Hz";
          example = 144;
        };
        alignOffsetX = mkOption {
          type = types.int;
          description = "The x-offset for the monitor relative to other monitors";
        };
        alignOffsetY = mkOption {
          type = types.int;
          description = "The y-offset for the monitor relative to other monitors";
        };
        wallpaper = mkOption {
          type = types.path;
          description = "The wallpaper to display on the monitor";
        };
        lockscreen = mkOption {
          type = types.nullOr types.path;
          description = "The lockscreen to display when idle. Defaults to wallpaper";
          default = null;
        };
      };
    };
  in {
    username = mkOption {
      type = types.str;
      description = "The username of the primary user on the host";
    };
    hostName = mkOption {
      type  = types.str;
      description = "The hostname of the host";
    };
    monitors = mkOption {
      type = types.listOf monitor;
      description = "The monitors used by the host";
    };
  };
}
