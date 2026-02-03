# Wallpaper Daemon
{ config, lib, self, ... }: {
  options = {
    modules.environments.desktop.wpaperd.enable = lib.mkEnableOption "the wpaperd wallpaper daemon";
  };

  config = lib.mkIf config.modules.environments.desktop.wpaperd.enable {
    services.wpaperd = {
      enable = true;

      # TOML
      settings = {
        default = {
          transition.directional-wipe = {};
          initial-transition = false;
        };

        # Internal Display
        "eDP-1" = {
          path = "${self}/assets/wallpapers/aurora-borealis-lofoten/catppuccin/stein-egil-liland_aurora-borealis-lofoten_catppuccin_macchiato.png";
          mode = "center";
        };

        # Undefined Displays
        any = {
          path = "${self}/assets/wallpapers/aurora-borealis-lofoten/catppuccin/stein-egil-liland_aurora-borealis-lofoten_catppuccin_macchiato.png";
          mode = "stretch";
        };
      };
    };
  };
}
