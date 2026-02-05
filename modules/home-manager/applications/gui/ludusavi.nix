# Game Save Data Backup Tool
{ config, lib, pkgs, ... }: {
  options = {
    modules.applications.gui.ludusavi.enable = lib.mkEnableOption "the Ludusavi game save data backup tool";
  };

  config = lib.mkIf config.modules.applications.gui.ludusavi.enable {
    services.ludusavi = {
      enable = true;

      settings = {
        release.check = false;

        roots = [
          {
            store = "heroic";
            path = "${config.xdg.configHome}/heroic";
          }

          {
            store = "heroic";
            path = "${config.home.homeDirectory}/Games/Heroic";
          }

          {
            store = "steam";
            path = "${config.xdg.dataHome}/Steam";
          }

          {
            store = "steam";
            path = "${config.home.homeDirectory}/Games/Steam";
          }
        ];

        backup = {
          filter.excludeStoreScreenshots = true;
          path = "${config.xdg.stateHome}/ludusavi";

          format = {
            chosen = "zip";
            zip.compression = "zstd";
          };

          retention = {
            full = 2;
            differential = 4;
          };
        };

        apps.rclone = {
          path = lib.getExe pkgs.rclone;
          arguments = "--fast-list --ignore-checksum";
        };

        cloud = {
          remote.WebDav = {
            id = "ludusavi";
            provider = "Nextcloud";
            url = "https://nextcloud.zerofisher.dev/remote.php/dav/files/lysan/Software/Backups/Games";
            username = "lysan";
          };

          path = "Ludusavi";
        };

        restore.path = "${config.xdg.stateHome}/ludusavi";
        theme = "dark";
      };

      backupNotification = true;
      frequency = "daily";
    };

    # Cloud Backups
    programs.rclone = {
      enable = true;

      remotes."${config.services.ludusavi.settings.cloud.remote.WebDav.id}" = {
        config = {
          vendor = "nextcloud";
          type = "webdav";
          url = config.services.ludusavi.settings.cloud.remote.WebDav.url;
          user = config.services.ludusavi.settings.cloud.remote.WebDav.username;
        };

        secrets.pass = config.sops.secrets."passwords/services/nextcloud".path;
      };
    };
  };
}
