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

        # Login Manager Session Entry
        gamescopeSession = {
          enable = true;

          args = [
            "--output-width 2560"
            "--output-height 1440"
            "--rt"
            "--expose-wayland"
          ];
        };

        extest.enable = true; # Steam Input on Wayland
        localNetworkGameTransfers.openFirewall = true; # TCP 27040
        dedicatedServer.openFirewall = true; # TCP/UDP 27015
        remotePlay.openFirewall = true; # TCP/UDP 27036, UDP 27031-27035
      };

      gamemode.enable = true; # Gaming Optimisations

      # Single-Window Wayland Compositor
      gamescope = {
        enable = true;
        capSysNice = true; # Raise Scheduler Priority
      };
    };

    environment.systemPackages = with pkgs; [
      steam-run # FHS Environment Runner
    ];
  };
}
