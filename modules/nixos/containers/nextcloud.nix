# Cloud Suite Server
{ config, lib, pkgs, nextcloud-compose, ... }: {
  options = {
    modules.containers.nextcloud.enable = lib.mkEnableOption "the Nextcloud cloud suite server";
  };

  config = lib.mkIf config.modules.containers.nextcloud.enable {
    modules.containers.caddy.enable = true; # Reverse Proxy

    sops.secrets = {
      "ssh-keys/hosts/accretion/nextcloud" = {};
      "environment-variables/nextcloud" = {};
    };

    # User Data
    fileSystems."/mnt/nextcloud" = {
      fsType = "sshfs";
      device = "u433534-sub2@u433534-sub2.your-storagebox.de:/home";

      options = [
        # SSH
        "Port=23"
        "IdentityFile=${config.sops.secrets."ssh-keys/hosts/accretion/nextcloud".path}"

        # File System
        "_netdev" # Network Device
        "noauto" # No Mount on Boot
        "x-systemd.automount" # Mount on Demand
        "allow_other" # Non-Root Access
        "gid=33" # WWW Data Group
        "uid=33" # WWW Data User
        "reconnect" # Handle Connection Drops
      ];
    };

    systemd.services.nextcloud = {
      description = "Nextcloud Cloud Suite Server";
      requires = [ "docker.service" "caddy.service" ];
      after = [ "docker.service" "caddy.service" ];

      environment = {
        NEXTCLOUD_DOMAIN = "nextcloud.zerofisher.dev";
        NEXTCLOUD_EMAIL_DOMAIN = "zerofisher.dev";
        NEXTCLOUD_SMTP_HOST = "smtp.mailbox.org";
      };

      serviceConfig = let docker = lib.getExe pkgs.docker; in {
        Type = "oneshot";
        RemainAfterExit = "yes";
        WorkingDirectory = nextcloud-compose;
        EnvironmentFile = config.sops.secrets."environment-variables/nextcloud".path;
        ExecStart = "${docker} compose up --remove-orphans --detach";
        ExecStop = "${docker} compose stop";
        TimeoutStopSec = "30s";
      };

      wantedBy = [ "multi-user.target" ];
    };
  };
}
