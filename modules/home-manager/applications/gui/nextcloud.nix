# File Synchronisation Client
{ config, lib, pkgs, ... }: {
  options = {
    modules.applications.gui.nextcloud.enable = lib.mkEnableOption "the Nextcloud file synchronisation client";
  };

  config = lib.mkIf config.modules.applications.gui.nextcloud.enable {
    services.nextcloud-client = {
      enable = true;
      startInBackground = true;
    };

    # Ignored Patterns
    home.file."Nextcloud/.sync-exclude.lst".text = builtins.concatStringsSep "\n" [
      "*.autosave.xopp"
      ".next"
      ".venv"
      "node_modules"
    ];

    xdg.desktopEntries.nextcloud = {
      name = "Nextcloud";
      genericName = "File Synchronisation Client";
      exec = lib.getExe pkgs.nextcloud-client;
      icon = "Nextcloud";
      categories = [ "Network" ];
    };
  };
}
