# PipeWire Audio Mixer
{ config, lib, pkgs, ... }: {
  options = {
    modules.applications.tui.wiremix.enable = lib.mkEnableOption "the wiremix PipeWire audio mixer";
  };

  config = lib.mkIf config.modules.applications.tui.wiremix.enable {
    home.packages = [ pkgs.wiremix ];
  };
}
