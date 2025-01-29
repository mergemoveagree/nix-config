{ lib
, config
, ...
}: with lib; {
  options.hostSpec = let
    monitor = types.submodule {
      options = {
        portName = mkOption {
          type = types.str;
          description = "The name of the port used by the monitor";
          example = "DP-1";
        };
        primary = mkOption {
          type = types.bool;
          description = "Whether the monitor is the primary monitor";
          default = false;
        };
        height = mkOption {
          type = types.ints.positive;
          description = "The height of the monitor";
          example = 1440;
        };
        width = mkOption {
          type = types.ints.positive;
          description = "The width of the monitor";
          example = 2560;
        };
        refreshRate = mkOption {
          type = types.ints.positive;
          description = "The refresh rate of the monitor in Hz";
          example = 144;
        };
        alignOffsetX = mkOption {
          type = types.int;
          description = "The x-offset for the monitor relative to other monitors";
          default = 0;
        };
        alignOffsetY = mkOption {
          type = types.int;
          description = "The y-offset for the monitor relative to other monitors";
          default = 0;
        };
        hdr = mkEnableOption "HDR features";
        wallpaper = mkOption {
          type = types.path;
          description = "The wallpaper to display on the monitor";
        };
        lockscreen = mkOption {
          type = types.nullOr types.path;
          description = "The lockscreen to display when idle. Defaults to wallpaper";
          default = null;
        };
        scale = mkOption {
          type = types.float;
          description = "The scale to use for the monitor";
          default = 1.0;
        };
      };
    };
  in {
    hostName = mkOption {
      type  = types.str;
      description = "The hostname of the host";
    };
    # TODO: Is this always wlan0 if I'm using iwd?
    netInterface = mkOption {
      type = types.str;
      description = "The network interface of the host";
      default = "wlan0";
    };
    enableZsh = mkEnableOption "ZSH features for primary user";
    doGaming = mkEnableOption "gaming features";
    isServer = mkOption {
      type = types.bool;
      description = "Whether the host is a server.";
      default = false;
    };
    gamemodeSettings = mkOption {
      type = types.nullOr submodule {
        gpu_device = mkOption {
          types = types.nullOr types.int.unsigned;
          description = "The index of the GPU device on the host";
          default = null;
        };
        amd_performance_level = mkOption {
          types = types.nullOr types.str;
          description = "The performance mode of the AMD GPU";
          default = null;
        };
      };
      default = null;
    };
    monitors = mkOption {
      type = types.listOf monitor;
      description = "The monitors used by the host";
      default = [];
    };
    hasRTC = mkOption {
      type = types.bool;
      description = "Whether the host has an RTC";
      default = true;
    };
  };

  # Ensure that only one monitor is primary
  config = mkIf (config.hostSpec.monitors != { }) {
    assertions = [
      (let
        primaries = catAttrs "portName" (filter (a: a.primary) config.hostSpec.monitors);
      in {
        assertion = length primaries == 1 || config.hostSpec.isServer;
        message = "Must have exactly one primary monitor for non-server hosts, but found "
          + toString (length primaries) + optionalString (length primaries > 1)
          (", namely " + concatStringSep ", " primaries);
      })
    ];
  };
}
