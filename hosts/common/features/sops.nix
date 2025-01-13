{ inputs
, ...
}: {
  imports = [ inputs.sops-nix.nixosModules.sops ];
  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_system_sops" ];
}
