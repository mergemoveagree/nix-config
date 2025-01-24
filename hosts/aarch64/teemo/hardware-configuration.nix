{
  boot = {
    initrd.availableKernelModules = [
      "usbhid"
      "usb_storage"
      "vc4"
      "pcie_brcmstb"
      "reset-raspberrypi"
    ];
    loader = {
      grub.enable = false;
      generic-extlinux-compatible.enable = false;
    };
    kernelParams = [ "kunit.enable=0" ];
  };
  hardware = {
    deviceTree.filter = "bcm2711-rpi-4*.dtb";
    enableRedistributableFirmware = true;
  };

  nixpkgs.hostPlatform.system = "aarch64-linux";

  powerManagement.cpuFreqGovernor = "ondemand";
}
