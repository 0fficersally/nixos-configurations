# Java Edition Servers
{ config, lib, minecraft-compose, ... }: {
  options = {
    modules.containers.minecraft.enable = lib.mkEnableOption "the Minecraft: Java Edition servers";
  };

  config = lib.mkIf config.modules.containers.minecraft.enable {
    sops.secrets."environment-variables/minecraft" = {};

    systemd.services.minecraft = {
      description = "Minecraft: Java Edition Servers";
      requires = [ "docker.service" ];
      after = [ "docker.service" ];

      environment = {
        MUSUBI_RETREAT_VERSION = "1.21.7";
        MUSUBI_RETREAT_MOTD = "§bMusubi Retreat§r・§a結びの隠れ家";
      };

      serviceConfig = let docker = lib.getExe pkgs.docker; in {
        Type = "oneshot";
        RemainAfterExit = "yes";
        WorkingDirectory = minecraft-compose;
        EnvironmentFile = config.sops.secrets."environment-variables/minecraft".path;
        ExecStart = "${docker} compose up --remove-orphans --detach";
        ExecStop = "${docker} compose stop";
        TimeoutStopSec = "30s";
      };

      wantedBy = [ "multi-user.target" ];
    };
  };
}
