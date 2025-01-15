{
  disko.devices.disk = {
    main = {
      type = "disk";
      device = "/dev/mmcblk0";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            size = "1G";
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
          luks = {
            size = "100%";
            content = {
              type = "luks";
              name = "crypted";
              passwordFile = "/tmp/secret.key";
              settings.allowDiscards = true;
              content = {
                type = "btrfs";
                extraArgs = [ "-f" ];
                subvolumes = {
                  "/@" = {
                    mountpoint = "/";
                    mountOptions = [ "compress-force=zstd" "space_cache=v2" "relatime" ];
                  };
                  "/@var" = {
                    mountpoint = "/var";
                    mountOptions = [ "compress-force=zstd" "space_cache=v2" "relatime" ];
                  };
                  "/@vartmp" = {
                    mountpoint = "/var/tmp";
                    mountOptions = [ "compress-force=zstd" "space_cache=v2" "relatime" ];
                  };
                  "/@home" = {
                    mountpoint = "/home";
                    mountOptions = [ "compress-force=zstd" "space_cache=v2" "relatime" ];
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
  };
}
