# Widget Toolkits
{ config, lib, pkgs, ... }: {
  options = {
    modules.appearance.toolkits.enable = lib.mkEnableOption "widget toolkit theming";
  };

  config = lib.mkIf config.modules.appearance.toolkits.enable {
    gtk = {
      enable = true;
      
      iconTheme = {
        package = pkgs.adwaita-icon-theme;
        name = "Adwaita";
      };

      gtk2.theme = {
        package = pkgs.gnome-themes-extra;
        name = "Adwaita-dark";
      };

      colorScheme = "dark";

      gtk3.theme = {
        package = pkgs.gtk3;
        name = "Adwaita";
      };

      gtk4.theme = {
        package = pkgs.gtk4;
        name = "Adwaita";
      };
    };

    qt = {
      enable = true;
      platformTheme.name = "adwaita";
      style.name = "adwaita-dark";
    };
  };
}
