{ pkgs
, ...
}: {
  environment.systemPackages = with pkgs; [
    clinfo
  ];

  hardware.graphics.extraPackages = with pkgs; [
    #rocmPackages.clr.icd
    stable.rocmPackages.clr.icd
  ];

}
