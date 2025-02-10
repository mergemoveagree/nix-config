{
  disko.devices.disk = {
    main = {
      type = "disk";
      device = "/dev/sda";
      content = {
        type = "gpt";
        partitions = {
          boot = {
            size = "500M";
            type = "EF02";
          };
          root = {
            size = "100%";
            content = {
              type = "btrfs";
              extraArgs = [ "-f" ];
              subvolumes = {
                "/@" = {
                  mountpoint = "/";
                  mountOptions = [ "compress-force=zstd" "space_cache=v2" "noatime" ];
                };
                "/@var" = {
                  mountpoint = "/var";
                  mountOptions = [ "compress-force=zstd" "space_cache=v2" "noatime" ];
                };
                "/@vartmp" = {
                  mountpoint = "/var/tmp";
                  mountOptions = [ "compress-force=zstd" "space_cache=v2" "noatime" ];
                };
                "/@home" = {
                  mountpoint = "/home";
                  mountOptions = [ "compress-force=zstd" "space_cache=v2" "noatime" ];
                };
                "/@nix" = {
                  mountpoint = "/nix";
                  mountOptions = [ "compress-force=zstd" "space_cache=v2" "noatime" ];
                };
                "/@swap" = {
                  mountpoint = "/swap";
                  swap.swapfile.size = "4G";
                };
              };
            };
          };
        };
      };
    };
  };
}
