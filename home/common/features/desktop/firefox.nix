{ pkgs
, ...
}: {
  programs.firefox.enable = true;
  programs.firefox.languagePacks = [ "en_US" ];
  programs.firefox.package = pkgs.wrapFirefox (pkgs.firefox-unwrapped.override { pipewireSupport = true; }) {
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
      ExtensionSettings = {
        "*".installation_mode = "blocked";
        "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/file/4340992/latest.xpi";
          installation_mode = "force_installed";
        };
        "browser-extension@anonaddy" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/file/4340302/latest.xpi";
          installation_mode = "force_installed";
        };
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
}
