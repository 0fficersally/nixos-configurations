# WakaTime Back End
{ config, lib, pkgs, wakapi-compose, ... }: {
  options = {
    modules.containers.wakapi.enable = lib.mkEnableOption "the Wakapi WakaTime back end";
  };

  config = lib.mkIf config.modules.containers.wakapi.enable {
    modules.containers.caddy.enable = true; # Reverse Proxy
    sops.secrets."environment-variables/wakapi" = {};

    systemd.services.wakapi = {
      description = "Wakapi WakaTime Back End";
      requires = [ "docker.service" "caddy.service" ];
      after = [ "docker.service" "caddy.service" ];

      serviceConfig = let docker = lib.getExe pkgs.docker; in {
        Type = "oneshot";
        RemainAfterExit = "yes";
        WorkingDirectory = wakapi-compose;
        EnvironmentFile = config.sops.secrets."environment-variables/wakapi".path;
        ExecStart = "${docker} compose up --remove-orphans --detach";
        ExecStop = "${docker} compose stop";
        TimeoutStopSec = "30s";
      };

      wantedBy = [ "multi-user.target" ];
    };
  };
}
