# System Information Fetcher
{ config, lib, ... }: {
  options = {
    modules.applications.cli.fastfetch.enable = lib.mkEnableOption "the fastfetch system information fetcher";
  };

  config = lib.mkIf config.modules.applications.cli.fastfetch.enable {
    programs.fastfetch = {
      enable = true;
    };
  };
}
