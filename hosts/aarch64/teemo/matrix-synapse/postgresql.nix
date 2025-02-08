{
  services.postgresql = {
    enable = true;
    ensureUsers = [
      {
        name = "matrix-synapse";
        ensureDBOwnership = true;
        ensureClauses.createrole = true;
      }
    ];
    ensureDatabases = [
      "matrix-synapse"
    ];
  };
}
