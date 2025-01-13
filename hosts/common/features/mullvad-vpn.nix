{ lib
, ...
}: {
  services.mullvad-vpn = {
    enable = true;
    enableExcludeWrapper = true;
  };

  sops.secrets.mullvad_account_number = {
    path = "/etc/mullvad-vpn/account-history.json";
    sopsFile = lib.custom.relativeToRoot "home/secrets.yml";
  };
}
