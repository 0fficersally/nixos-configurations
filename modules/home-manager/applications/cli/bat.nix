# File Viewer
{ config, lib, ... }: {
  options = {
    modules.applications.cli.bat.enable = lib.mkEnableOption "the bat file viewer";
  };

  config = lib.mkIf config.modules.applications.cli.bat.enable {
    programs.bat = {
      enable = true;
      config.theme = "Catppuccin Macchiato";
    };
  };
}
