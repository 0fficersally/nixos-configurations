# File Manager
{ config, lib, pkgs, ... }: {
  options = {
    modules.applications.gui.dolphin.enable = lib.mkEnableOption "the Dolphin file manager";
  };

  config = lib.mkIf config.modules.applications.gui.dolphin.enable {
    home.packages = with pkgs; [ kdePackages.dolphin ];

    qt.kde.settings.kdeglobals = {
      General.TerminalApplication = lib.getExe pkgs.kitty;
      UiSettings.ColorScheme = "qt6ct"; # [Workaround](https://www.reddit.com/r/hyprland/comments/1kb1jtn/comment/mpti646)
      "Colors:View".BackgroundNormal = "#00000000"; # [Workaround](https://github.com/prasanthrangan/hyprdots/issues/1843)
    };

    xdg = {
      enable = true;

      mimeApps.defaultApplications = {
        "inode/directory" = [ "org.kde.dolphin.desktop" ];
        "x-scheme-handler/file" = [ "org.kde.dolphin.desktop" ];
      };
    };
  };
}
