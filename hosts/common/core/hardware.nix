{ config
, ...
}: {
  hardware.graphics = {
    enable = true;
    enable32Bit = config.hostSpec.doGaming;
  };
}
