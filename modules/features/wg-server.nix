{ lib
, config
, pkgs
, ...
}: with lib; let
  cfg = config.custom-wg-server;
in {
  options.custom-wg-server = {
    enable = mkEnableOption "the custom wireguard server";
    interfaceName = mkOption {
      type = types.str;
      description = "Name of the wireguard interface";
      default = "wg0";
    };
    port = mkOption {
      type = types.port;
      description = "Port used by the wireguard server";
      default = 51820;
    };
    forwardedPorts = mkOption {
      type = types.listOf (types.submodule {
        options = {
          port = mkOption {
            type = types.port;
            description = "Port to forward to peer";
          };
          address = mkOption {
            type = types.str;
            description = "Peer address to forward traffic";
          };
        };
      });
      description = "List of ports to forward to peers";
      default = [ ];
    };
    peerPublicKeys = mkOption {
      type = types.listOf types.str;
      description = "Public keys of the wireguard client peers";
    };
  };

  config = lib.mkIf cfg.enable (let
    inherit (pkgs) system;
    platform = if system == "x86_64-linux" then "nixos" else lib.removeSuffix "-linux" system;
  in {
    sops.secrets."${config.hostSpec.hostName}_wireguard_private_key" = {
      key = "wireguard_private_key";
      sopsFile = lib.custom.relativeToRoot "hosts/${platform}/${config.hostSpec.hostName}/secrets.yml";
    };

    boot.kernel.sysctl."net.ipv4.ip_forward" = lib.mkForce 1;

    networking = {
      nat = {
        enable = true;
        externalInterface = config.hostSpec.netInterface;
        internalInterfaces = [ cfg.interfaceName ];
      };

      firewall = {
        allowedUDPPorts = [ cfg.port ];
        extraCommands = let
          attrToRule = { address, port }: "${pkgs.iptables}/bin/iptables -t nat -A PREROUTING -p tcp --dport ${toString port} -j DNAT --to-destination ${address}:${toString port}";
        in concatMapStringsSep "\n" attrToRule cfg.forwardedPorts;
      };

      wireguard = {
        enable = true;
        interfaces.${cfg.interfaceName} = {
          ips = [ "10.100.0.1/24" ];
          listenPort = cfg.port;
          privateKeyFile = config.sops.secrets."${config.hostSpec.hostName}_wireguard_private_key".path;
          postSetup = ''
            ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.100.0.0/24 -o ${config.hostSpec.netInterface} -j MASQUERADE
          '';
          postShutdown = ''
            ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.100.0.0/24 -o ${config.hostSpec.netInterface} -j MASQUERADE
          '';
          peers = imap1 (index: publicKey: {
            inherit publicKey;
            allowedIPs = [ "10.100.0.${toString (index + 1)}/32" ];
          }) cfg.peerPublicKeys;
        };
      };
    };
  });
}
