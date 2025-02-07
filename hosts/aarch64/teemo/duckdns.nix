{ pkgs
, config
, ...
}: let
  duckdns-update-script = pkgs.writeScript "duckdns-update" ''
    DOMAIN="$(cat ${config.sops.secrets."duckdns_domain".path})"
    TOKEN="$(cat ${config.sops.secrets."duckdns_token".path})"
    response="$(echo url='https://www.duckdns.org/update?domains=''${DOMAIN}&token=''${TOKEN}&ip=' | curl -skK -)"
    if [ "$response" != "OK" ]; then
      exit 1
    fi
  '';
in {
  sops.secrets = {
    "duckdns_domain".sopsFile = ./secrets.yml;
    "duckdns_token".sopsFile = ./secrets.yml;
  };

  services.cron = {
    enable = true;
    systemCronJobs = [
      "*/5 * * * * ${duckdns-update-script} >/dev/null 2>&1"
    ];
  };
}
