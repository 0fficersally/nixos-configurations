# Gaming Platform
{ config, lib, pkgs, ... }: {
  options = {
    modules.applications.gui.steam.enable = lib.mkEnableOption "the Steam gaming platform";
  };

  config = lib.mkIf config.modules.applications.gui.steam.enable {
    programs = {
      steam = {
        enable = true;
        extraCompatPackages = [ pkgs.proton-ge-bin ]; # Compatibility Tools
        gamescopeSession.enable = true; # Login Manager Session Entry
        extest.enable = true; # Steam Input on Wayland
        localNetworkGameTransfers.openFirewall = true; # TCP 27040
        dedicatedServer.openFirewall = true; # TCP/UDP 27015
        remotePlay.openFirewall = true; # TCP/UDP 27036, UDP 27031-27035
      };

      # Single-Window Wayland Compositor
      gamescope = {
        enable = true;
        capSysNice = true; # Raise Scheduler Priority

        args = [
          "--rt"
          "--adaptive-sync"
          "--expose-wayland"
          "--nested-width 2560"
          "--nested-height 1600"
          "--steam"
        ];
      };
    };

    environment.systemPackages = with pkgs; [
      steam-run # FHS Environment Runner
    ];
  };
}
