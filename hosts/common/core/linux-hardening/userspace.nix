{
  boot.kernel.sysctl."sysctl.kernel.yama.ptrace_scope" = 2;
  boot.kernel.sysctl."sysctl.vm.mmap_rnd_bits" = 32;
  boot.kernel.sysctl."sysctl.vm.mmap_rnd_compat_bits" = 16;
  boot.kernel.sysctl."sysctl.fs.protected_symlinks" = 1;
  boot.kernel.sysctl."sysctl.fs.protected_hardlinks" = 1;
  boot.kernel.sysctl."sysctl.fs.protected_fifos" = 2;
  boot.kernel.sysctl."sysctl.fs.protected_regular" = 2;
}
