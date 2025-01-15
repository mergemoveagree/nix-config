{ config
, pkgs
, lib
, ...
}: {
  sops.secrets = builtins.listToAttrs (map (sec: { name = sec; value = lib.custom.relativeToRoot "home/user/secrets.yml"; }) [
    "user_email_address"
    "user_email_password"
    "user_email_imap_host"
    "user_email_imap_port"
    "user_email_smtp_host"
    "user_email_smtp_port"
  ]);

  accounts.email.accounts.main = rec {
    primary = true;
    realName = "Jaden Nola";
    address = config.sops.secrets."user_email_address";
    userName = address;
    passwordCommand = "${pkgs.coreutils}/bin/cat ${config.sops.secrets."user_email_password".path}";
    flavor = "plain";
    gpg = {
      key = "282872FA4AF162DE";
      signByDefault = false;
      encryptByDefault = false;
    };
    imap = {
      host = config.sops.secrets."user_email_imap_host";
      port = config.sops.secrets."user_email_imap_port";
      tls.enable = true;
    };
    smtp = {
      host = config.sops.secrets."user_email_smtp_host";
      port = config.sops.secrets."user_email_smtp_port";
      tls.enable = true;
    };
  };
}
