{ pkgs
, config
, ...
}: let
  njalla-ddns-update-script = pkgs.writeScript "njalla-ddns-update" ''
    DOMAIN="$(cat ${config.sops.secrets."njalla_ddns_domain".path})"
    TOKEN="$(cat ${config.sops.secrets."njalla_ddns_token".path})"
    response="$(${pkgs.curl}/bin/curl -s "https://njal.la/update/?h=''${DOMAIN}&k=''${TOKEN}&auto" | ${pkgs.jq}/bin/jq '.status')"
    if [ "$response" != "200" ]; then
      exit 1
    fi
  '';
in {
  sops.secrets = {
    "njalla_ddns_domain".sopsFile = ./secrets.yml;
    "njalla_ddns_token".sopsFile = ./secrets.yml;
  };

  services.cron = {
    enable = true;
    systemCronJobs = [
      "*/5 * * * * ${njalla-ddns-update-script} >/dev/null 2>&1"
    ];
  };
}
