# Reverse Proxy
{ config, lib, pkgs, caddy-compose, ... }: {
  options = {
    modules.containers.caddy.enable = lib.mkEnableOption "the Caddy reverse proxy";
  };

  config = lib.mkIf config.modules.containers.caddy.enable {
    systemd.services.caddy = {
      description = "Caddy Reverse Proxy";
      requires = [ "docker.service" ];
      after = [ "docker.service" ];
      environment.CADDY_EMAIL = "lysander.fontyn@zerofisher.dev";

      serviceConfig = let docker = lib.getExe pkgs.docker; in {
        Type = "oneshot";
        RemainAfterExit = "yes";
        WorkingDirectory = caddy-compose;
        ExecStart = "${docker} compose up --remove-orphans --detach";
        ExecStop = "${docker} compose stop";
        TimeoutStopSec = "30s";
      };

      wantedBy = [ "multi-user.target" ];
    };
  };
}
