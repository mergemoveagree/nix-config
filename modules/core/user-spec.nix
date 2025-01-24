{ lib
, ...
}: with lib; let
  userSubmodule = types.submodule {
    options = {
      userName = mkOption {
        type = types.str;
        description = "The username of the user.";
        default = _module.args.name;
      };
      sopsFile = mkOption {
        type = types.path;
        description = "The sops file responsible for the user password";
        default = lib.custom.relativeToRoot "home/secrets.yml";
      };
    };
  };
in {
  options.userSpec = mkOption {
    type = types.attrsOf userSubmodule;
    description = "User accounts to create for the system";
    default = { };
  };
}
