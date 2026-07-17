{ config, lib, pkgs, home-manager, ... }: {
  options = {
    modules.hardware.gpus.amd.enable = lib.mkEnableOption "AMD GPU support";
  };

  config = lib.mkIf config.modules.hardware.gpus.amd.enable {
    programs.gamescope.env = { DRI_PRIME = "1"; }; # Use Discrete Graphics
  };
}
