{
  services.chrony = {
    enable = true;
    enableNTS = true;
    enableRTCTrimming = true;
    servers = [
      "ohio.time.system76.com"
      "oregon.time.system76.com"
      "virginia.time.system76.com"
      "stratum1.time.cifelli.xyz"
      "time.cifelli.xyz"
      "time.txryan.com"
    ];
    serverOption = "iburst";
    extraConfig = ''
      cmdport 0
    '';
  };
}
