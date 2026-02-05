# Screen Recording and Livestreaming Software
{ config, lib, ... }: {
  options = {
    modules.applications.gui.obsStudio.enable = lib.mkEnableOption "the OBS Studio screen recording and livestreaming software";
  };

  config = lib.mkIf config.modules.applications.gui.obsStudio.enable {
    programs.obs-studio = {
      enable = true;
    };
  };
}
