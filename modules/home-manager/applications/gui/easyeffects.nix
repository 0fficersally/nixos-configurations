# Audio Manipulation Tool
{ config, lib, ... }: {
  options = {
    modules.applications.gui.easyeffects.enable = lib.mkEnableOption "the Easy Effects audio manipulation tool";
  };

  config = lib.mkIf config.modules.applications.gui.easyeffects.enable {
    services.easyeffects = {
      enable = true;
    };
  };
}
