# Secure Shell Client
{ config, lib, ... }: {
  options = {
    modules.applications.cli.openssh.enable = lib.mkEnableOption "the OpenSSH SSH client";
  };

  config = lib.mkIf config.modules.applications.cli.openssh.enable {
    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;

      settings = {
        # Remote Server
        "Host ruby" = {
          AddKeysToAgent = "yes";
          HostName = "ruby.zerofisher.dev";
          IdentityFile = config.sops.secrets."ssh-keys/hosts/ruby".path;
        };

        # Git Hosting Service
        "Host github.com" = {
          IdentitiesOnly = "yes";

          IdentityFile = [
            "~/.ssh/id_ed25519_yubikey_github"
            config.sops.secrets."ssh-keys/services/github".path # Fallback
          ];
        };

        # Defaults
        "Host *" = {
          AddKeysToAgent = "no";
          Compression = "no";
          ControlMaster = "no";
          ControlPath = "~/.ssh/master-%r@%n:%p";
          ControlPersist = "no";
          ForwardAgent = "no";
          HashKnownHosts = "no";
          ServerAliveCountMax = 3;
          ServerAliveInterval = 0;
          UserKnownHostsFile = "~/.ssh/known_hosts";
        };
      };
    };
  };
}
