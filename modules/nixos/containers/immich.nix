# Photo and Video Management Server
{ config, lib, pkgs, immich-compose, ... }: {
  options = {
    modules.containers.immich.enable = lib.mkEnableOption "the Immich photo and video management server";
  };

  config = lib.mkIf config.modules.containers.immich.enable {
    modules.containers.caddy.enable = true; # Reverse Proxy

    sops.secrets = {
      "ssh-keys/hosts/accretion/immich" = {};
      "environment-variables/immich" = {};
    };

    # User Data
    fileSystems."/mnt/immich" = {
      fsType = "sshfs";
      device = "u433534-sub1@u433534-sub1.your-storagebox.de:/home";

      options = [
        # SSH
        "Port=23"
        "IdentityFile=${config.sops.secrets."ssh-keys/hosts/accretion/immich".path}"

        # File System
        "_netdev" # Network Device
        "noauto" # No Mount on Boot
        "x-systemd.automount" # Mount on Demand
        "allow_other" # Non-Root Access
        "reconnect" # Handle Connection Drops
      ];
    };

    systemd.services.immich = {
      description = "Immich Photo and Video Management Server";
      requires = [ "docker.service" "caddy.service" ];
      after = [ "docker.service" "caddy.service" ];

      serviceConfig = let docker = lib.getExe pkgs.docker; in {
        Type = "oneshot";
        RemainAfterExit = "yes";
        WorkingDirectory = immich-compose;
        EnvironmentFile = config.sops.secrets."environment-variables/immich".path;
        ExecStart = "${docker} compose up --remove-orphans --detach";
        ExecStop = "${docker} compose stop";
        TimeoutStopSec = "30s";
      };

      wantedBy = [ "multi-user.target" ];
    };
  };
}
