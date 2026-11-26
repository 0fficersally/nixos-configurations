# BitTorrent Client
{ config, lib, ... }: {
  options = {
    modules.applications.gui.qbittorrent.enable = lib.mkEnableOption "the qBittorrent BitTorrent client";
  };

  config = lib.mkIf config.modules.applications.gui.qbittorrent.enable {
    services.qbittorrent = {
      enable = true;

      serverConfig.Preferences.WebUI = {
        Enabled = true;
        Address = "127.0.0.1";
        LocalHostAuth = false;
      };

      webuiPort = 7333;
    };
  };
}
