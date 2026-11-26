# Scrollable-Tiling Wayland Compositor
{ config, lib, ... }: {
  options = {
    modules.environments.desktop.compositors.niri.enable = lib.mkEnableOption "the niri scrollable-tiling Wayland compositor";
  };

  config = lib.mkIf config.modules.environments.desktop.compositors.niri.enable {
    programs.niri.enable = true;
    home-manager.users.lysan.modules.environments.desktop.compositors.niri.enable = true; # Home Manager Module
  };
}
