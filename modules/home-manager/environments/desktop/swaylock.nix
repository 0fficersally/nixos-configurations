# Screen Locking Utility
{ config, lib, self, ... }: {
  options = {
    modules.environments.desktop.swaylock.enable = lib.mkEnableOption "the swaylock screen locking utility";
  };

  config = lib.mkIf config.modules.environments.desktop.swaylock.enable {
    programs.swaylock = {
      enable = true;

      settings = {
        image = "${self}/assets/wallpapers/cloudy-quasar/catppuccin/kurzgesagt_cloudy-quasar_catppuccin_macchiato.png";
      };
    };
  };
}
