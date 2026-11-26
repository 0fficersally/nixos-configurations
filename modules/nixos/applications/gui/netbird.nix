# Mesh VPN Client
{ config, lib, ... }: {
  options = {
    modules.applications.gui.netbird.enable = lib.mkEnableOption "the NetBird mesh VPN client";
  };

  config = lib.mkIf config.modules.applications.gui.netbird.enable {
    services.netbird = {
      enable = true;
      clients.default.environment.NB_MANAGEMENT_URL = "https://netbird.zerofisher.dev";
      ui.enable = true;
    };
  };
}
