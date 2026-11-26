# Virtual Private Network
{ config, lib, windscribe-nix, ... }: {
  options = {
    modules.applications.gui.windscribe.enable = lib.mkEnableOption "the Windscribe virtual private network";
  };

  config = lib.mkIf config.modules.applications.gui.windscribe.enable {
    nixpkgs.overlays = [ windscribe-nix.overlays.default ];
    services.windscribe.enable = true;
  };
}
