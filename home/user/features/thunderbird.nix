{ config
, ...
}: {
  programs.thunderbird = {
    enable = true;
    profiles."Main" = {
      isDefault = true;
      withExternalGnupg = true;
      settings = {
        "mail.openpgp.fetch_pubkeys_from_gnupg" = true;
        "mail.openpgp.alias_rules_file" = "file://${config.xdg.configHome}/thunderbird_pgp_aliases.json";
      };
    };
  };

  xdg.configFile."thunderbird_pgp_aliases.json".source = ./thunderbird-aliases.json;

  accounts.email.accounts."main".thunderbird = {
    enable = true;
    profiles = [ "Main" ];
  };
}
