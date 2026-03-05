# Internet Metasearch Engine
{ config, lib, pkgs, searxng-compose, ... }: {
  options = {
    modules.containers.searxng.enable = lib.mkEnableOption "the SearXNG internet metasearch engine";
  };

  config = lib.mkIf config.modules.containers.searxng.enable {
    modules.containers.caddy.enable = true; # Reverse Proxy
    sops.secrets."environment-variables/searxng" = {};

    systemd.services.searxng = {
      description = "SearXNG Internet Metasearch Engine";
      requires = [ "docker.service" "caddy.service" ];
      after = [ "docker.service" "caddy.service" ];
      environment.SEARXNG_DOMAIN = "searxng.zerofisher.dev";

      serviceConfig = let docker = lib.getExe pkgs.docker; in {
        Type = "oneshot";
        RemainAfterExit = "yes";
        WorkingDirectory = searxng-compose;
        EnvironmentFile = config.sops.secrets."environment-variables/searxng".path;
        ExecStart = "${docker} compose up --remove-orphans --detach";
        ExecStop = "${docker} compose stop";
        TimeoutStopSec = "30s";
      };

      wantedBy = [ "multi-user.target" ];
    };
  };
}
