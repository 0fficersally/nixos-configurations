# Terminal Session Recorder
{ config, lib, pkgs, ... }: {
  options = {
    modules.applications.cli.asciinema.enable = lib.mkEnableOption "the asciinema terminal session recorder";
  };

  config = lib.mkIf config.modules.applications.cli.asciinema.enable {
    programs.asciinema = {
      enable = true;
    };

    home.packages = with pkgs; [ asciinema-agg ]; # GIF Generator
  };
}
