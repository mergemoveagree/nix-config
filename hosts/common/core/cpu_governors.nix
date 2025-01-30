{ config
, lib
, ...
}: {
  services.power-profiles-daemon.enable = ! config.hostSpec.portable;

  services.tlp = lib.mkIf config.hostSpec.portable {
    enable = true;
    settings = {
      CPU_ENERGY_PERF_POLICY_ON_AC = "balance_performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      START_CHARGE_THRESH_BAT0 = 85;
      STOP_CHARGE_THRESH_BAT0 = 95;
      DEVICES_TO_DISABLE_ON_LAN_CONNECT = "wifi";
    };
  };
}
