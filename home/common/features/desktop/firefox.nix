{ pkgs
, ...
}: {
  programs.firefox = {
    enable = true;
    languagePacks = [ "en_US" ];
    package = pkgs.wrapFirefox (pkgs.firefox-unwrapped.override { pipewireSupport = true; }) {
      extraPolicies = {
        SearchSuggestEnabled = false;
        FirefoxSuggest = {
          WebSuggestions = false;
          SponsoredSuggestions = false;
          ImproveSuggest = false;
          Locked = true;
        };
        HttpsOnlyMode = "force_enabled";
        EnableTrackingProtection = {
          Value = true;
          Locked = true;
          Cryptomining = true;
          Fingerprinting = true;
          Exceptions = [];
        };
        SanitizeOnShutdown = {
          Cache = true;
          Cookies = true;
          Sessions = true;
          SiteSettings = true;
          OfflineApps = true;
          Locked = true;
        };
        FirefoxHome = {
          Search = true;
          TopSites = true;
          SponsoredTopSites = false;
          Highlights = false;
          Pocket = false;
          SponsoredPocket = false;
          Snippets = true;
          Locked = true;
        };
        InstallAddonsPermission = {
          "Allow" = [];
          "Default" = false;
        };
        DisplayBookmarksToolbar = "always";
        DisplayMenuBar = "default-off";
        SearchBar = "unified";
        DisablePocket = true;
        DisableFormHistory = true;
        DisableFirefoxStudies = true;
        DisableFirefoxAccounts = true;
        AutofillAddressEnabled = false;
        AutofillCreditCardEnabled = false;
        NoDefaultBookmarks = true;
        OfferToSaveLogins = false;
        OfferToSaveLoginsDefault = false;
        DisableMasterPasswordCreation = true;
        DisableTelemetry = true;
        PasswordManagerEnabled = false;
        HardwareAcceleration = true;
      };
    };
    profiles.main = {
      isDefault = true;
      extensions = with pkgs.nur.repos.rycee.firefox-addons; [
        addy_io
        bitwarden
        privacy-redirect
      ];
    };
  };
}
