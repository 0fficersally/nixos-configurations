{ config, lib, pkgs, nixos-secrets, ... }: {
  imports = [
    ../../modules/home-manager # Home Manager Modules
  ];

  nixpkgs.config = {
    allowUnfreePredicate = package: builtins.elem (lib.getName package) [
      "obsidian"
      "osu-lazer-bin"
      "steam-unwrapped"
      "tetrio-desktop"
    ];

    rocmSupport = true; # AMD GPU Computing Stack
  };

  modules = {
    # User Background Processes
    daemons = {
      mpd.enable = true; # Music Player Daemon
    };

    # User Sessions
    environments = {
      terminal = {
        kitty.enable = true; # Terminal Emulator

        # Command-Line Interpreters
        shells = {
          bash.enable = true; # Bourne Again Shell
          zsh.enable = true; # Z Shell
        };

        starship.enable = true; # Cross-Shell Prompt
      };

      desktop = {
        compositors.niri.enable = true; # Scrollable-Tiling Wayland Compositor
        shells.noctalia.enable = true; # Desktop Shell
      };
    };

    applications = {
      # Command-Line Interface
      cli = {
        asciinema.enable = true; # Terminal Session Recorder
        bat.enable = true; # File Viewer
        fastfetch.enable = true; # System Information Fetcher
        git.enable = true; # Version Control System
        github.enable = true; # GitHub Command-Line Tool
        openssh.enable = true; # Secure Shell Client
        rbw.enable = true; # Bitwarden (Password Manager)
        whipper.enable = true; # CD-DA Ripper
      };

      # Terminal User Interface
      tui = {
        btop.enable = true; # Resource Monitor
        cava.enable = true; # Audio Visualiser
        lazygit.enable = true; # Git Client
        neovim.enable = true; # Text Editor
        rmpc.enable = true; # MPD Client
        wiremix.enable = true; # PipeWire Audio Mixer
        yazi.enable = true; # File Manager
      };

      # Graphical User Interface
      gui = {
        anki.enable = true; # Flashcard Program
        bottles.enable = true; # Wine Prefix Manager
        chromium.enable = true; # Web Browser (Blink Engine)
        cryptomator.enable = true; # Cloud Storage Encryption Program
        dbeaver.enable = true; # Database Management Tool
        dolphin.enable = true; # File Manager
        easyeffects.enable = true; # Audio Manipulation Tool
        floorp.enable = true; # Web Browser (Gecko Engine)
        geeqie.enable = true; # Image Viewer and Organiser
        ludusavi.enable = true; # Game Save Data Backup Tool
        nextcloud.enable = true; # File Synchronisation Client
        obsidian.enable = true; # Personal Knowledge Base
        obsStudio.enable = true; # Screen Recording and Livestreaming Software
        prismLauncher.enable = true; # Minecraft Launcher
        satty.enable = true; # Screenshot Annotation Tool
        sober.enable = true; # Roblox Player (Gaming Platform)
        thunderbird.enable = true; # PIM Suite
        vesktop.enable = true; # Discord (Social Platform)
        vsCode.enable = true; # Integrated Development Environment
      };
    };

    # UI Customisation
    appearance = {
      fonts.enable = true; # Typography
      toolkits.enable = true; # Widget Toolkits
      pointer.enable = true; # Mouse Pointer
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
      "ssh-keys/hosts/quasar".path = "${homeDirectory}/.ssh/id_ed25519_quasar";

      # API Keys
      "api-keys/wakatime" = {};
    };
  };

  # User Environment
  home = {
    stateVersion = "25.11"; # Configuration Defaults
    username = "lysan";
    homeDirectory = "/home/lysan";

    packages = with pkgs; [
      # CLI Applications
      _7zz # File Archiver (7-Zip)
      croc # File Sharing
      libqalculate # Multipurpose Calculator
      yubikey-manager # Hardware Security Keys

      # TUI Applications
      bluetui # Bluetooth Manager
      gdu # Disk Usage Analyser
      podman-tui # Container Dashboard
      wifitui # Wi-Fi Manager

      # Desktop Utilities
      hyprpicker # Colour Picker

      # GUI Applications
      audacity # Audio Editor
      blender # 3D Creation Suite
      brush-splat # 3D Reconstruction Engine
      colmap # SfM and MVS Pipeline
      eid-mw # Belgian Electronic ID Middleware
      gimp3 # Image Manipulation
      godot # Game Engine
      inkscape # Vector Graphics Editor
      kdePackages.ark # Archive Manager
      kdePackages.kdenlive # Video Editor
      krita # Digital Painting
      libreoffice # Office Suite
      meld # File Comparison
      musescore # Music Notation
      naps2 # Document Scanner
      openutau # Singing Synthesiser
      pdfarranger # PDF Page Arranger
      piper # Gaming Mouse Configuration
      qalculate-qt # Multipurpose Calculator
      qbittorrent # BitTorrent Client
      qpwgraph # Audio Patchbay
      scrcpy # Android Remote Control
      sidequest # Meta Quest Sideloading
      vlc # Media Player
      xournalpp # Note-Taking
      yaak # API Client

      # Gaming Applications
      heroic # Multiplatform Game Launcher
      itch # Indie Game Launcher
      osu-lazer-bin # Rhythm Game
      tetrio-desktop # Online Stacker Game
    ];

    # WakaTime Configuration
    file.".wakatime.cfg".text = ''
      [settings]
      api_key_vault_cmd = cat ${config.sops.secrets."api-keys/wakatime".path}
    '';
  };

  xdg = {
    enable = true;

    userDirs = {
      createDirectories = true;
      desktop = null;
      publicShare = null;
    };

    mimeApps.enable = true;
  };

  systemd.user.services.mbsync.unitConfig.After = [ "sops-nix.service" ];

  services = {
    playerctld.enable = true; # MPRIS Media Controls

    # Sandboxed App Distribution
    flatpak = {
      uninstallUnmanaged = true; # Avoid Accumulation

      packages = [
        "com.wonderlandengine.editor" # 3D Web Engine
      ];
    };

    mpris-proxy.enable = true; # Bluetooth Media Controls
  };

  programs = {
    home-manager.enable = true; # Manage Itself
  };
}
