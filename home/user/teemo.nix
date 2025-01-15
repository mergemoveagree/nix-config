{ lib
, ...
}: {
  imports = lib.flatten [
    (map lib.custom.relativeToRoot [
      "home/common/core"
    ])

    ./global
  ];
}
