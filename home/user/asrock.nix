{ lib
, ...
}: {
  imports = (map lib.custom.relativeToRoot [
    "home/common/core"
  ]);
}
