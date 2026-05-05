# Wine Prefix Manager
{ config, lib, nix-flatpak, ... }: {
  options = {
    modules.applications.gui.bottles.enable = lib.mkEnableOption "the Bottles Wine prefix manager";
  };

  config = lib.mkIf config.modules.applications.gui.bottles.enable {
    services.flatpak = {
      packages = [ "com.usebottles.bottles" ];
      overrides."com.usebottles.bottles".Context.filesystems = [ "${config.home.homeDirectory}/Nextcloud" ];
    };
  };
}
