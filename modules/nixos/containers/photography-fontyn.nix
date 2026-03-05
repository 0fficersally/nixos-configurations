# Photography Website
{ config, lib, photography-fontyn, ... }: {
  options = {
    modules.containers.photographyFontyn.enable = lib.mkEnableOption "the Photography Fontyn photography website";
  };

  config = lib.mkIf config.modules.containers.photographyFontyn.enable {
    modules.containers.caddy.enable = true; # Reverse Proxy
    sops.secrets."environment-variables/photography-fontyn" = {};

    systemd.services.photography-fontyn = {
      description = "Photography Fontyn Photography Website";
      requires = [ "docker.service" "caddy.service" ];
      after = [ "docker.service" "caddy.service" ];

      serviceConfig = let docker = lib.getExe pkgs.docker; in {
        Type = "oneshot";
        RemainAfterExit = "yes";
        WorkingDirectory = photography-fontyn;
        EnvironmentFile = config.sops.secrets."environment-variables/photography-fontyn".path;
        ExecStart = "${docker} compose up --remove-orphans --detach";
        ExecStop = "${docker} compose stop";
        TimeoutStopSec = "30s";
      };

      wantedBy = [ "multi-user.target" ];
    };
  };
}
