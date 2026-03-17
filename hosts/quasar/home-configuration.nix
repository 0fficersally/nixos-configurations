{ config, pkgs, nixos-secrets, ... }: {
  imports = [
    ../../modules/home-manager # Home Manager Modules
  ];

  modules = {
    # User Sessions
    environments = {
      terminal = {
        # Command-Line Interpreters
        shells = {
          bash.enable = true; # Bourne Again Shell
          zsh.enable = true; # Z Shell
        };

        starship.enable = true; # Cross-Shell Prompt
      };
    };

    applications = {
      # Command-Line Interface
      cli = {
        fastfetch.enable = true; # System Information Fetcher
        git.enable = true; # Version Control System
      };

      # Terminal User Interface
      tui = {
        btop.enable = true; # Resource Monitor
        neovim.enable = true; # Text Editor
        yazi.enable = true; # File Manager
      };
    };
  };

  # Secret Provisioning
  sops = let homeDirectory = config.home.homeDirectory; in {
    defaultSopsFile = "${nixos-secrets}/secrets.yaml";
    age.keyFile = "${config.xdg.configHome}/sops/age/keys.txt";
    validateSopsFiles = false;

    secrets = {
      # SSH Keys
      "ssh-keys/services/github".path = "${homeDirectory}/.ssh/id_ed25519_github";
    };
  };

  # User Environment
  home = {
    stateVersion = "25.11"; # Configuration Defaults
    username = "lysan";
    homeDirectory = "/home/lysan";

    packages = with pkgs; [
      # TUI Applications
      lazydocker # Docker Container Dashboard
      podman-tui # Podman Container Dashboard
    ];
  };

  systemd.user.services.mbsync.unitConfig.After = [ "sops-nix.service" ];

  programs = {
    home-manager.enable = true; # Manage Itself
  };
}
