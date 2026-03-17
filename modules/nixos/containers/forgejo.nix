# Software Forge
{ config, lib, pkgs, forgejo-compose, ... }: {
  options = {
    modules.containers.forgejo.enable = lib.mkEnableOption "the Forgejo software forge";
  };

  config = lib.mkIf config.modules.containers.forgejo.enable {
    modules.containers.caddy.enable = true; # Reverse Proxy
    sops.secrets."environment-variables/forgejo" = {};

    systemd.services.forgejo = {
      description = "Forgejo Software Forge";
      requires = [ "docker.service" "caddy.service" ];
      after = [ "docker.service" "caddy.service" ];

      serviceConfig = let docker = lib.getExe pkgs.docker; in {
        Type = "oneshot";
        RemainAfterExit = "yes";
        WorkingDirectory = forgejo-compose;
        EnvironmentFile = config.sops.secrets."environment-variables/forgejo".path;
        ExecStart = "${docker} compose up --remove-orphans --detach";
        ExecStop = "${docker} compose stop";
        TimeoutStopSec = "30s";
      };

      wantedBy = [ "multi-user.target" ];
    };
  };
}
