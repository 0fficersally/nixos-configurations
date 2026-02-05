# File Manager
{ config, lib, pkgs, ... }: {
  options = {
    modules.applications.gui.nemo.enable = lib.mkEnableOption "the Nemo file manager";
  };

  config = lib.mkIf config.modules.applications.gui.nemo.enable {
    home.packages = with pkgs; [(nemo-with-extensions.override {
      useDefaultExtensions = false;

      extensions = [
        nemo-fileroller
        nemo-preview
        nemo-python
        nemo-seahorse
      ];
    })];

    dconf.settings."org/nemo/preferences".desktop-is-home-dir = true; # Prevent Desktop Directory Creation

    xdg = {
      enable = true;

      desktopEntries.nemo = {
        name = "Nemo";
        exec = lib.getExe pkgs.nemo;
      };

      mimeApps.defaultApplications = {
        "application/x-gnome-saved-search" = [ "nemo.desktop" ];
        "inode/directory" = [ "nemo.desktop" ];
        "x-scheme-handler/file" = [ "nemo.desktop" ];
      };
    };
  };
}
