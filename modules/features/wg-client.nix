{ lib
, config
, pkgs
, ...
}: with lib; let
  cfg = config.custom-wg-client;
in {
  options.custom-wg-client = {
    enable = mkEnableOption "the custom wireguard client";
    port = mkOption {
      type = types.port;
      description = "Port used by the wireguard client";
      default = 51820;
    };
    # TODO: Integrate default gateway with hostSpec module
    defaultGateway = mkOption {
      type = types.str;
      description = "Default gateway of the client";
    };
    # TODO: Allow more than one server
    server = mkOption {
      type = types.submodule {
        options = {
          interfaceName = mkOption {
            type = types.nullOr types.str;
            description = "Name of the interface to communicate with the server";
            default = "wg0";
          };
          interfaceIp = mkOption {
            type = types.nullOr types.str;
            description = "Local IPv4 address of the wireguard interface";
          };
          endpoint = mkOption {
            type = types.str;
            description = "IPv4 address of the server";
          };
          publicKey = mkOption {
            type = types.str;
            description = "Public key of the wireguard server";
          };
        };
      };
      description = "Connection information for the wireguard server";
    };
  };

  config = mkIf cfg.enable (let
    inherit (pkgs) system;
    platform = if system == "x86_64-linux" then "nixos" else lib.removeSuffix "-linux" system;
  in {
    sops.secrets."${config.hostSpec.hostName}_wireguard_private_key" = {
      key = "wireguard_private_key";
      sopsFile = lib.custom.relativeToRoot "hosts/${platform}/${config.hostSpec.hostName}/secrets.yml";
    };

    networking = {
      firewall.allowedUDPPorts = [ cfg.port ];
      interfaces.${config.hostSpec.netInterface}.ipv4.routes = [{
        address = cfg.server.endpoint;
        prefixLength = 24;
        via = cfg.defaultGateway;
      }];
      wireguard = {
        enable = true;
        interfaces.${cfg.server.interfaceName}= {
          ips = [ "${cfg.server.interfaceIp}/24" ];
          listenPort = cfg.port;
          privateKeyFile = config.sops.secrets."${config.hostSpec.hostName}_wireguard_private_key".path;
          peers = [
            {
              inherit (cfg.server) publicKey;
              allowedIPs = [ "0.0.0.0/0" ];
              endpoint = "${cfg.server.endpoint}:${toString cfg.port}";
              persistentKeepalive = 25;
            }
          ];
        };
      };
    };
  });
}
