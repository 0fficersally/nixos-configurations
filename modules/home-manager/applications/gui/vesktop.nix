# Discord (Social Platform)
{ config, lib, ... }: {
  options = {
    modules.applications.gui.vesktop.enable = lib.mkEnableOption "the Vesktop third-party Discord client";
  };

  config = lib.mkIf config.modules.applications.gui.vesktop.enable {
    programs.vesktop = {
      enable = true;

      settings = {
        discordBranch = "stable";
        splashColor = "#efeff0";
        autoStartMinimized = true;
        minimizeToTray = true;
        clickTrayToShowHide = true;
        disableMinSize = true;
        arRPC = true;
      };
    };

    xdg.mimeApps.defaultApplications."x-scheme-handler/discord" = [ "vesktop.desktop" ];
  };
}
