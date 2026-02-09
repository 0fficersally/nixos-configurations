{ config, pkgs, nixos-secrets, ... }: {
  imports = [
    ./hardware-configuration.nix # Hardware Scan
    ../../modules/nixos # NixOS Modules
  ];

  system.stateVersion = "25.05"; # Configuration Defaults
  nixpkgs.config.allowUnfree = true; # Proprietary Software

  modules = {
    hardware.gpus.nvidia.enable = true;
    applications.gui.steam.enable = true;
  };

  hardware = {
    graphics.enable = true; # Mesa 3D Library

    bluetooth = {
      enable = true;

      settings.General = {
        Enable = "Media,Sink,Socket,Source"; # Profiles
        Experimental = true; # Battery Service
      };

      powerOnBoot = true;
    };

    opentabletdriver.enable = true; # Graphics Tablets

    # Image Scanners
    sane = {
      enable = true;

      extraBackends = with pkgs; [
        hplipWithPlugin # HP
      ];
    };
  };

  time.timeZone = "Europe/Brussels";

  boot.loader = {
    efi.canTouchEfiVariables = true;

    grub = {
      enable = true;
      efiSupport = true;
      device = "nodev";

      extraEntries = ''
        menuentry "Restart System" {
          reboot
        }

        menuentry "Shut Down System" {
          halt
        }
      '';
    };
  };

  security = {
    rtkit.enable = true; # Real-Time Processing
    polkit.enable = true; # Privilege Management
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
    hostName = "aurora";

    # Network Connectivity
    networkmanager = {
      enable = true;
      wifi.powersave = true;
    };
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

    secrets = {
      # SSH Keys
      "ssh-keys/services/github".path = "/root/.ssh/id_ed25519_github";

      # Passwords
      "passwords/users/lysan".neededForUsers = true;
    };
  };

  # System Environment
  environment = {
    systemPackages = with pkgs; [
      age # Encryption Tool
      android-tools # Android SDK Platform-Tools
      brightnessctl # Backlight Control
      hydra-check # Package Build Status Checker
      nixfmt # Nix Formatter
      nurl # Nix Fetcher Call Generator
      sops # Secret Management
      tree # Recursive Directory Listing
    ];

    sessionVariables.NIXOS_OZONE_WL = "1"; # Chromium Wayland Support
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
    # Multimedia Framework
    pipewire = {
      enable = true;

      # Advanced Linux Sound Architecture
      alsa = {
        enable = true;
        support32Bit = true;
      };

      pulse.enable = true; # PulseAudio
      jack.enable = true; # JACK Audio Connection Kit
    };

    ratbagd.enable = true; # Gaming Mouse Configuration
    printing.enable = true; # CUPS

    # Service Discovery
    avahi = {
      enable = true;
      nssmdns4 = true; # NSS (IPv4) Plugin
      openFirewall = true; # UDP 5353
    };

    gnome.gnome-keyring.enable = true; # Secret Service Provider

    # Secure Shell Server
    openssh = {
      enable = true;

      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
      };
    };

    # Display Server
    xserver = {
      enable = true;
      xkb.layout = "be"; # Keyboard
    };

    # Login Manager
    displayManager = {
      enable = true;

      sddm = {
        enable = true;
        wayland.enable = true;
      };
    };

    flatpak.enable = true; # Sandboxed App Distribution
  };

  virtualisation = {
    containers.enable = true;

    podman = {
      enable = true;
      defaultNetwork.settings.dns_enabled = true; # Bridge Network (UDP 53)
    };

    oci-containers.backend = "podman";
  };

  programs = {
    zsh.enable = true; # Z Shell
    gnupg.agent.enable = true; # GNU Privacy Guard

    # Secure Shell Client
    ssh.extraConfig = ''
      Host github.com
        IdentitiesOnly yes
        IdentityFile ~/.ssh/id_ed25519_yubikey_github
        IdentityFile ${config.sops.secrets."ssh-keys/services/github".path}
    '';

    # Scrollable-Tiling Wayland Compositor
    niri = {
      enable = true;
      package = pkgs.niri; # Override Flake
    };

    # Tiling Wayland Compositor
    sway = {
      enable = true;
      package = pkgs.swayfx; # Eye Candy
      wrapperFeatures.gtk = true; # GTK Compatibility
    };

    localsend.enable = true; # LAN File Sharing (TCP/UDP 53317)
  };

  users = {
    mutableUsers = false; # Make Declarative

    users.lysan = {
      isNormalUser = true;

      # Privileges
      extraGroups = [
        "wheel" # Root User
        "video" # Video Devices
        "networkmanager" # Network Connections
        "podman" # Containers
        "adbusers" # Android Debug Bridge
        "scanner" # Image Scanners
        "lp" # Printers
      ];

      hashedPasswordFile = config.sops.secrets."passwords/users/lysan".path;
      description = "Lysander Fontyn";
      shell = pkgs.zsh; # Z Shell
    };
  };
}
