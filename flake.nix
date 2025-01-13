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
        modules = [
          ./hosts/nixos/${host}
          inputs.disko.nixosModules.disko
          ./hosts/nixos/${host}/disk.nix
        ];
        specialArgs = {
          inherit
            inputs
          ;
        };
      };
    };
    mkHostConfigs = hosts: lib.foldl (acc: built: acc // built) {} (lib.map (host: mkHost host) hosts);
    readHosts = folder: lib.attrNames (builtins.readDir ./hosts/${folder});
  in {
    nixosConfigurations = mkHostConfigs (readHosts "nixos");

    devShells.x86_64-linux.default = let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
    in pkgs.mkShell {
      NIX_CONFIG = "extra-experimental-features = nix-command flakes";
      nativeBuildInputs = with pkgs; [
        git
        git-crypt
        sops
        gnupg
        age
        ssh-to-age
        pcsclite
        ccid
      ];
    };
  };
}
