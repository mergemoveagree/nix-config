{ pkgs
, ...
}: {
  services.postgresql = {
    enable = true;
    initialScript = pkgs.writeText "init-psql-script" ''
      CREATE ROLE "matrix-synapse";
      CREATE DATABASE "matrix-synapse" WITH OWNER "matrix-synapse"
        TEMPLATE template0
        LC_COLLATE = "C"
        LC_CTYPE = "C";
    '';
    ensureUsers = [
      {
        name = "matrix-synapse";
        ensureDBOwnership = true;
        ensureClauses.login = true;
      }
    ];
    ensureDatabases = [ "matrix-synapse" ];
  };
}
