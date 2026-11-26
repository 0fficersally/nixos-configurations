# University of Applied Sciences
{ config, lib, pkgs, ... }: {
  options = {
    modules.specialisations.thomasMore.enable = lib.mkEnableOption "the Thomas More specialisation";
  };

  config = lib.mkIf config.modules.specialisations.thomasMore.enable {
    specialisation.thomas-more.configuration = {
      programs.openvpn3.enable = true; # OpenVPN 3 Client

      home-manager.users.lysan = {
        nixpkgs.config.allowUnfreePackages = [
          "cisco-packet-tracer"
          "CiscoPacketTracer_901_Ubuntu_64bit.deb"
        ];

        home.packages = with pkgs; [
          cisco-packet-tracer_9 # Network Simulation Tool
        ];
      };
    };
  };
}
