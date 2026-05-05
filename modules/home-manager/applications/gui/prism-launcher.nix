# Minecraft Launcher
{ config, lib, ... }: {
  options = {
    modules.applications.gui.prismLauncher.enable = lib.mkEnableOption "the Prism Launcher Minecraft launcher";
  };

  config = lib.mkIf config.modules.applications.gui.prismLauncher.enable {
    programs.prismlauncher = {
      enable = true;
    };
  };
}
