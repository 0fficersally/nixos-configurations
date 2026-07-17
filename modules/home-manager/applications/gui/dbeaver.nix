# Database Management Tool
{ config, lib, ... }: {
  options = {
    modules.applications.gui.dbeaver.enable = lib.mkEnableOption "the DBeaver database management tool";
  };

  config = lib.mkIf config.modules.applications.gui.dbeaver.enable {
    programs.dbeaver = {
      enable = true;
    };
  };
}
