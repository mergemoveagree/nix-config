{
  disko.devices.disk = {
    main = {
      type = "disk";
      device = "/dev/sda";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            size = "500M";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/efi";
              mountOptions = [
                "defaults"
                "dmask=0077"
                "fmask=0077"
              ];
            };
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
              };
            };
          };
        };
      };
    };
  };
}
