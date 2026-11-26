# Wayland Compositor
{ config, lib, ... }: {
  options = {
    modules.environments.desktop.compositors.umbriel.enable = lib.mkEnableOption "the Umbriel Wayland compositor";
  };

  config = lib.mkIf config.modules.environments.desktop.compositors.umbriel.enable {
    programs.umbriel.enable = true;
    home-manager.users.lysan.modules.environments.desktop.compositors.umbriel.enable = true; # Home Manager Module
  };
}
