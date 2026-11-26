# Web Browser (Blink Engine)
{ config, lib, pkgs, helium-browser-nix-flake, ... }: {
  options = {
    modules.applications.gui.helium.enable = lib.mkEnableOption "the Helium web browser";
  };

  config = lib.mkIf config.modules.applications.gui.helium.enable {
    nixpkgs.overlays = [ helium-browser-nix-flake.overlays.default ];
    home.packages = with pkgs; [ helium ];
  };
}
