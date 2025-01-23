{
  description = "mergemoveagree's NixOS configuration";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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

    hyprland.url = "github:hyprwm/Hyprland";

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hardware.url = "github:nixos/nixos-hardware";
  };

  outputs = {self, nixpkgs, ...}@inputs: let
    inherit (self) outputs;
    inherit (nixpkgs) lib;
    mkHost = host: system: {
      ${host} = lib.nixosSystem {
        inherit system;
        modules = let
          platform = if system == "x86_64-linux" then "nixos" else system;
        in [
          ./hosts/${platform}/${host}
          inputs.disko.nixosModules.disko
          ./hosts/${platform}/${host}/disk.nix
          ./hosts/${platform}/${host}/hardware-configuration.nix
          {
            nixpkgs.overlays = [
              inputs.nur.overlays.default
            ];
          }
        ];
        specialArgs = {
          inherit
            inputs
            outputs
          ;

          lib = nixpkgs.lib.extend (self: super: { custom = import ./lib { inherit (nixpkgs) lib; }; });
        };
      };
    };
    mkHostConfigs = hosts: system: lib.foldl (acc: built: acc // built) {} (lib.map (host: mkHost host system) hosts);
    readHosts = folder: lib.attrNames (builtins.readDir ./hosts/${folder});
  in {
    overlays = import ./overlays { inherit inputs; };

    nixosConfigurations = 
      (mkHostConfigs (readHosts "nixos") "x86_64-linux")
      // (mkHost "teemo" "aarch64")
    ;

    devShells.x86_64-linux.default = let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
    in pkgs.mkShell {
      NIX_CONFIG = "extra-experimental-features = nix-command flakes";
      nativeBuildInputs = with pkgs; [
        git
        git-crypt
        sops
        gnupg
        just
        age
        ssh-to-age
        pcsclite
        ccid
      ];
    };
  };
}
