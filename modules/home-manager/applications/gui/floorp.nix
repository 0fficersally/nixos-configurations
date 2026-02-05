# Web Browser (Gecko Engine)
{ config, lib, pkgs, ... }: {
  options = {
    modules.applications.gui.floorp.enable = lib.mkEnableOption "the Floorp web browser";
  };

  config = lib.mkIf config.modules.applications.gui.floorp.enable {
    programs.floorp = {
      enable = true;
      release = "147.0"; # Upstream Version ([Workaround](https://github.com/nix-community/home-manager/pull/6784))
      pkcs11Modules = [ pkgs.eid-mw ];
      languagePacks = [ "en-GB" "en-US" ];

      policies.ExtensionSettings = let getInstallUrl = id: "https://addons.mozilla.org/firefox/downloads/latest/${id}/latest.xpi"; in {
        # Bitwarden
        "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
          install_url = getInstallUrl "bitwarden-password-manager";
          installation_mode = "force_installed";
          default_area = "navbar";
          private_browsing = true;
        };

        # BTRoblox
        "btroblox@antiboomz.com" = {
          install_url = getInstallUrl "btroblox";
          installation_mode = "force_installed";
          default_area = "menupanel";
          private_browsing = true;
        };

        # Facebook Container
        "@contain-facebook" = {
          install_url = getInstallUrl "facebook-container";
          installation_mode = "force_installed";
          default_area = "menupanel";
          private_browsing = true;
        };

        # Firefox Color
        "FirefoxColor@mozilla.com" = {
          install_url = getInstallUrl "firefox-color";
          installation_mode = "force_installed";
          default_area = "menupanel";
          private_browsing = true;
        };

        # ImprovedTube
        "{3c6bf0cc-3ae2-42fb-9993-0d33104fdcaf}" = {
          install_url = getInstallUrl "youtube-addon";
          installation_mode = "force_installed";
          default_area = "menupanel";
          private_browsing = true;
        };

        # LanguageTool
        "languagetool-webextension@languagetool.org" = {
          install_url = getInstallUrl "languagetool";
          installation_mode = "force_installed";
          default_area = "menupanel";
          private_browsing = false; # Proprietary
        };

        # Refined GitHub
        "{a4c4eda4-fb84-4a84-b4a1-f7c1cbf2a1ad}" = {
          install_url = getInstallUrl "refined-github-";
          installation_mode = "force_installed";
          default_area = "menupanel";
          private_browsing = true;
        };

        # Return YouTube Dislike
        "{762f9885-5a13-4abd-9c77-433dcd38b8fd}" = {
          install_url = getInstallUrl "return-youtube-dislikes";
          installation_mode = "force_installed";
          default_area = "menupanel";
          private_browsing = true;
        };

        # SteamDB
        "firefox-extension@steamdb.info" = {
          install_url = getInstallUrl "steam-database";
          installation_mode = "force_installed";
          default_area = "menupanel";
          private_browsing = true;
        };

        # Stylus
        "{7a7a4a92-a2a0-41d1-9fd7-1e92480d612d}" = {
          install_url = getInstallUrl "styl-us";
          installation_mode = "force_installed";
          default_area = "menupanel";
          private_browsing = true;
        };

        # uBlock Origin
        "uBlock0@raymondhill.net" = {
          install_url = getInstallUrl "ublock-origin";
          installation_mode = "force_installed";
          default_area = "navbar";
          private_browsing = true;
        };

        # User-Agent Switcher and Manager
        "{a6c4a591-f1b2-4f03-b3ff-767e5bedf4e7}" = {
          install_url = getInstallUrl "user-agent-string-switcher";
          installation_mode = "force_installed";
          default_area = "navbar";
          private_browsing = true;
        };

        # Violentmonkey
        "{aecec67f-0d10-4fa7-b7c7-609a2db280cf}" = {
          install_url = getInstallUrl "violentmonkey";
          installation_mode = "force_installed";
          default_area = "navbar";
          private_browsing = true;
        };
      };
    };

    xdg.mimeApps.defaultApplications = {
      "application/pdf" = [ "floorp.desktop" ];
      "x-scheme-handler/http" = [ "floorp.desktop" ];
      "x-scheme-handler/https" = [ "floorp.desktop" ];
    };
  };
}
