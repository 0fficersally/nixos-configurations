{ config, pkgs, nixos-secrets, ... }: {
  imports = [
    ./hardware-configuration.nix # Hardware Scan
    ../../modules/nixos # NixOS Modules
  ];

  system.stateVersion = "25.11"; # Configuration Defaults

  modules = {
    containers = {
      forgejo.enable = true; # Software Forge
      immich.enable = true; # Photo and Video Management Server
      minecraft.enable = true; # Java Edition Servers
      nextcloud.enable = true; # Cloud Suite Server
      photographyFontyn.enable = true; # Photography Website
      searxng.enable = true; # Internet Metasearch Engine
      wakapi.enable = true; # WakaTime Back End
    };
  };

  time.timeZone = "Europe/Brussels";

  boot.loader = {
    efi.canTouchEfiVariables = true;
    systemd-boot.enable = true;
  };

  # Internationalisation
  i18n = {
    defaultLocale = "en_GB.UTF-8";

    extraLocaleSettings = {
      LC_ADDRESS = "nl_BE.UTF-8";
      LC_IDENTIFICATION = "nl_BE.UTF-8";
      LC_MEASUREMENT = "nl_BE.UTF-8";
      LC_MONETARY = "nl_BE.UTF-8";
      LC_NAME = "nl_BE.UTF-8";
      LC_NUMERIC = "nl_BE.UTF-8";
      LC_PAPER = "nl_BE.UTF-8";
      LC_TELEPHONE = "nl_BE.UTF-8";
      LC_TIME = "nl_BE.UTF-8";
    };
  };

  console.keyMap = "be-latin1"; # Keyboard Layout

  networking = {
    hostName = "quasar";
    networkmanager.enable = true; # Network Connectivity
  };

  # Secret Provisioning
  sops = {
    defaultSopsFile = "${nixos-secrets}/secrets.yaml";

    age = {
      sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
      keyFile = "/var/lib/sops-nix/key.txt";
      generateKey = true;
    };

    validateSopsFiles = false;
    secrets."passwords/users/lysan".neededForUsers = true;
  };

  # System Environment
  environment = {
    systemPackages = with pkgs; [
      age # Encryption Tool
      nixfmt # Nix Formatter
      sops # Secret Management
      tree # Recursive Directory Listing
    ];
  };

  nix = {
    settings.experimental-features = [ "nix-command" "flakes" ];

    # Garbage Collection
    gc = {
      options = "--delete-older-than 30d";
      automatic = true;
      dates = "Sat 20:00";
    };

    # Storage Optimisation
    optimise = {
      automatic = true;
      dates = "Sun 20:00";
    };
  };

  services = {
    fail2ban.enable = true;

    # Secure Shell Server
    openssh = {
      enable = true;

      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
      };
    };
  };

  virtualisation = {
    docker.enable = true;
    podman.enable = true;
  };

  programs = {
    zsh.enable = true; # Z Shell

    # Secure Shell Client
    ssh.extraConfig = ''
      Host github.com
        IdentitiesOnly yes
        IdentityFile ${config.sops.secrets."ssh-keys/services/github".path}
    '';
  };

  users = {
    mutableUsers = false; # Make Declarative

    users.lysan = {
      description = "Lysander Fontyn";
      isNormalUser = true;

      # Privileges
      extraGroups = [
        "wheel" # Root User
        "networkmanager" # Network Connections
      ];

      hashedPasswordFile = config.sops.secrets."passwords/users/lysan".path;
      shell = pkgs.zsh; # Z Shell
    };
  };
}
