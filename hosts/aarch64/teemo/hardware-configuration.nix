{
  boot = {
    initrd = {
      availableKernelModules = ["xhci_pci"];
    };
    loader.timeout = 5;
  };

  hardware.raspberry-pi."4" = {
    i2c1.enable = true;
    fkms-3d.enable = true;
  };

  nixpkgs.hostPlatform.system = "aarch64-linux";

  powerManagement.cpuFreqGovernor = "ondemand";
}
