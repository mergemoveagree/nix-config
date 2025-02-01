{ inputs
, lib
, config
, ...
}: {
  imports = [ inputs.sops-nix.nixosModules.sops ];
  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
}
// lib.mkIf config.hostSpec.enableHomeManager {
    home-manager.sharedModules = lib.optional (inputs ? "sops-nix") inputs.sops-nix.homeManagerModules.sops;
}
