{
  disko.devices.disk = {
    "0" = {
      type = "disk";
      device = "/dev/disk/by-id/nvme-CT2000P5PSSD8_23133F7360CC-part1";
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
          mdadm = {
            size = "100%";
            content = {
              type = "mdraid";
              name = "root";
            };
          };
        };
      };
    };
    "1" = {
      type = "disk";
      device = "/dev/disk/by-id/nvme-WD_BLACK_SN770_2TB_24193M807673-part1";
      content = {
        type = "gpt";
        partitions = {
          extra = {
            size = "1G";
            content = {
              type = "filesystem";
              format = "ext4";
            };
          };
          mdadm = {
            size = "100%";
            content = {
              type = "mdraid";
              name = "root";
            };
          };
        };
      };
    };
  };
  disko.devices.mdadm.root = {
    type = "mdadm";
    level = 0;
    content = {
      type = "luks";
      name = "cryptroot";
      passwordFile = "/tmp/secret.key";
      settings.allowDiscards = true;
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
}
