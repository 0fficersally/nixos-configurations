# GitHub Command-Line Tool
{ config, lib, ... }: {
  options = {
    modules.applications.cli.github.enable = lib.mkEnableOption "the GitHub command-line tool";
  };

  config = lib.mkIf config.modules.applications.cli.github.enable {
    programs.gh = {
      enable = true;
    };
  };
}
