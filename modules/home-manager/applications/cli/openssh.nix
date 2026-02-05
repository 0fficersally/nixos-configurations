# Secure Shell Client
{ config, lib, ... }: {
  options = {
    modules.applications.cli.openssh.enable = lib.mkEnableOption "the OpenSSH SSH client";
  };

  config = lib.mkIf config.modules.applications.cli.openssh.enable {
    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;

      matchBlocks = {
        # Defaults
        "*" = {
          forwardAgent = false;
          addKeysToAgent = "no";
          userKnownHostsFile = "~/.ssh/known_hosts";
          hashKnownHosts = false;
          compression = false;
          serverAliveInterval = 0;
          serverAliveCountMax = 3;
          controlMaster = "no";
          controlPath = "~/.ssh/master-%r@%n:%p";
          controlPersist = "no";
        };

        # Git Hosting Service
        "github.com" = {
          identitiesOnly = true;

          identityFile = [
            "~/.ssh/id_ed25519_yubikey_github"
            config.sops.secrets."ssh-keys/services/github".path # Fallback
          ];
        };

        # Remote Server
        "quasar" = {
          hostname = "quasar.zerofisher.dev";
          addKeysToAgent = "yes";
          identityFile = config.sops.secrets."ssh-keys/hosts/quasar".path;
        };
      };
    };
  };
}
