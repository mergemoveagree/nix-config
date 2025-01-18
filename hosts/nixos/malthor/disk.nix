{
  disko.devices = {
    disk.main = {
      type = "disk";
      device = "/dev/sda";
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
                type = "lvm_pv";
                vg = "pool";
              };
            };
          };
        };
      };
    };
    lvm_vg = {
      pool = {
        type = "lvm_vg";
        lvs = {
          root = {
            size = "32G";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/";
              mountOptions = [
                "defaults"
              ];
            };
          };
          var = {
            size = "64G";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/var";
              mountOptions = [
                "defaults"
              ];
            };
          };
          nix = {
            size = "200G";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/nix";
              mountOptions = [
                "noatime"
              ];
            };
          };
          swap = {
            size = "8G";
            content = {
              type = "swap";
              discardPolicy = "both";
            };
          };
          home = {
            size = "80%FREE";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/home";
              mountOptions = [
                "defaults"
              ];
            };
          };
        };
      };
    };
  };
}
