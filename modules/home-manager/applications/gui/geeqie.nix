# Image Viewer and Organiser
{ config, lib, pkgs, ... }: {
  options = {
    modules.applications.gui.geeqie.enable = lib.mkEnableOption "the Geeqie image viewer and organiser";
  };

  config = lib.mkIf config.modules.applications.gui.geeqie.enable {
    home.packages = [ pkgs.geeqie ];

    xdg.mimeApps.defaultApplications = {
      "image/gif" = [ "Geeqie.desktop" ];
      "image/jpeg" = [ "Geeqie.desktop" ];
      "image/png" = [ "Geeqie.desktop" ];
      "image/svg+xml" = [ "Geeqie.desktop" ];
      "image/webp" = [ "Geeqie.desktop" ];
    };
  };
}
