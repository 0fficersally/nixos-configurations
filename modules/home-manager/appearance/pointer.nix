# Mouse Pointer
{ config, lib, pkgs, ... }: {
  options = {
    modules.appearance.pointer.enable = lib.mkEnableOption "mouse pointer theming";
  };

  config = lib.mkIf config.modules.appearance.pointer.enable {
    home.pointerCursor = {
      enable = true;
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
      size = 24;
      x11.enable = true;
      gtk.enable = true;
    };
  };
}
