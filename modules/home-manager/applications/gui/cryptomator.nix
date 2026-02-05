# Cloud Storage Encryption Program
{ config, lib, pkgs, ... }: {
  options = {
    modules.applications.gui.cryptomator.enable = lib.mkEnableOption "the Cryptomator cloud storage encryption program";
  };

  config = lib.mkIf config.modules.applications.gui.cryptomator.enable {
    home.packages = [ pkgs.cryptomator ];

    xdg.autostart = {
      enable = true;
      entries = [ "${pkgs.cryptomator}/share/applications/org.cryptomator.Cryptomator.desktop" ];
    };
  };
}
