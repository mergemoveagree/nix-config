{
  boot.kernel.sysctl."kernel.kptr_restrict" = 2;
  boot.kernel.sysctl."kernel.dmesg_restrict" = 1;
  boot.kernel.sysctl."kernel.printk" = "3 3 3 3";
  boot.kernel.sysctl."kernel.unprivileged_bpf_disabled" = 1;
  boot.kernel.sysctl."net.core.bpf_jit_harden" = 2;
  boot.kernel.sysctl."dev.tty.ldisc_autoload" = 0;
  boot.kernel.sysctl."vm.unprivileged_userfaultfd" = 0;
  boot.kernel.sysctl."kernel.kexec_load_disabled" = 1;
  boot.kernel.sysctl."kernel.sysrq" = 4;
  boot.kernel.sysctl."kernel.unprivileged_userns_clone" = 0;
  boot.kernel.sysctl."kernel.perf_event_paranoid" = 3;

  # TODO: Move network filesystems to different module (maybe will eventually need on another host?)
  boot.extraModprobeConfig = ''
    install dccp /bin/false
    install sctp /bin/false
    install rds /bin/false
    install tipc /bin/false
    install n-hdlc /bin/false
    install ax25 /bin/false
    install netrom /bin/false
    install x25 /bin/false
    install rose /bin/false
    install decnet /bin/false
    install econet /bin/false
    install af_802154 /bin/false
    install ipx /bin/false
    install appletalk /bin/false
    install psnap /bin/false
    install p8023 /bin/false
    install p8022 /bin/false
    install can /bin/false
    install atm /bin/false

    install cramfs /bin/false
    install freevxfs /bin/false
    install jffs2 /bin/false
    install hfs /bin/false
    install hfsplus /bin/false
    install squashfs /bin/false
    install udf /bin/false

    install cifs /bin/true
    install nfs /bin/true
    install nfsv3 /bin/true
    install nfsv4 /bin/true
    install ksmbd /bin/true
    install gfs2 /bin/true

    install vivid /bin/false
  '';
}
