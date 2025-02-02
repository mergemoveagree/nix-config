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

    lanzaboote = {
      url = "github:nix-community/lanzaboote";
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
    mkHost = host: system: {
      ${host} = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = let
          platform = if system == "x86_64-linux" then "nixos" else nixpkgs.lib.removeSuffix "-linux" system;
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
  in {
    overlays = import ./overlays { inherit inputs; };

    nixosConfigurations = nixpkgs.lib.mergeAttrsList [
      (mkHost "asrock" "x86_64-linux")
      (mkHost "thinkpadx1" "x86_64-linux")
      (mkHost "malthor" "x86_64-linux")
      (mkHost "teemo" "aarch64-linux")
      (mkHost "hyeonseong" "x86_64-linux")
    ];

    devShells = nixpkgs.lib.genAttrs [
      "x86_64-linux"
      "aarch64-linux"
    ] (name: let
      pkgs = nixpkgs.legacyPackages.${name};
    in {
      default = pkgs.mkShell {
        NIX_CONFIG = ''
          extra-experimental-features = nix-command flakes
          extra-substituters = https://hyprland.cachix.org
          extra-trusted-public-keys = hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=
        '';
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
    });
  };
}
