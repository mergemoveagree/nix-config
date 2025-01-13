{
  description = "mergemoveagree's NixOS configuration";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {self, nixpkgs, ...}@inputs: let
    inherit (nixpkgs) lib;
    mkHost = host: {
      ${host} = lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit
            inputs
          ;
        };
      };
      modules = [ ./hosts/nixos/${host} ];
    };
    mkHostConfigs = hosts: lib.foldl (acc: built: acc // built) {} (lib.map (host: mkHost host) hosts);
    readHosts = folder: lib.attrNames (builtins.readDir ./hosts/${folder});
  in {
    nixosConfigurations = mkHostConfigs (readHosts "nixos");
  };
}
