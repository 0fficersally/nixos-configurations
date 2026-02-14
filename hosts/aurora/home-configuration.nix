{ config, pkgs, nixos-secrets, ... }: {
  imports = [
    ../../modules/home-manager # Home Manager Modules
  ];

  nixpkgs.config.allowUnfree = true; # Proprietary Software

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
        # Wayland Display Servers
        compositors = {
          niri.enable = true; # Scrollable-Tiling Wayland Compositor
          sway.enable = true; # Tiling Wayland Compositor
        };

        wpaperd.enable = true; # Wallpaper Daemon
        waybar.enable = true; # Status Bar
        swayosd.enable = true; # On-Screen Display
        swaynotificationcenter.enable = true; # Notification Daemon
        rofi.enable = true; # Application Launcher
        swayidle.enable = true; # Idle Management Daemon
        swaylock.enable = true; # Screen Locking Utility
      };
    };

    applications = {
      # Command-Line Interface
      cli = {
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
        chromium.enable = true; # Web Browser (Blink Engine)
        cryptomator.enable = true; # Cloud Storage Encryption Program
        floorp.enable = true; # Web Browser (Gecko Engine)
        geeqie.enable = true; # Image Viewer and Organiser
        ludusavi.enable = true; # Game Save Data Backup Tool
        nemo.enable = true; # File Manager
        nextcloud.enable = true; # File Synchronisation Client
        obsStudio.enable = true; # Screen Recording and Livestreaming Software
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
      "api-keys/listenbrainz" = {};
      "api-keys/wakatime" = {};

      # Passwords
      "passwords/services/nextcloud" = {};

      # Email Addresses
      "email-addresses/personal" = {};
    };
  };

  # User Environment
  home = {
    stateVersion = "25.05"; # Configuration Defaults
    username = "lysan";
    homeDirectory = "/home/lysan";

    packages = with pkgs; [
      # CLI Applications
      _7zz # File Archiver (7-Zip)
      asciinema # Terminal Session Recorder
      asciinema-agg # Asciinema GIF Generator
      croc # File Sharing
      libqalculate # Multipurpose Calculator
      playerctl # MPRIS Media Controls
      yubikey-manager # Hardware Security Keys

      # TUI Applications
      bluetui # Bluetooth Manager
      gdu # Disk Usage Analyser
      podman-tui # Podman Dashboard
      wifitui # Wi-Fi Manager

      # Desktop Utilities
      hyprpicker # Colour Picker

      # GUI Applications
      audacity # Audio Editor
      blender # 3D Creation Suite
      dbeaver-bin # Database Management Tool
      eid-mw # Belgian Electronic ID Middleware
      file-roller # Archive Manager
      gimp3 # Image Manipulation
      godot # Game Engine
      inkscape # Vector Graphics Editor
      kdePackages.kdenlive # Video Editor
      krita # Digital Painting
      libreoffice # Office Suite
      meld # File Comparison
      musescore # Music Notation
      naps2 # Document Scanner
      obsidian # Personal Knowledge Base
      openutau # Singing Synthesiser
      pdfarranger # PDF Page Arranger
      piper # Gaming Mouse Configuration
      qalculate-gtk # Multipurpose Calculator
      qpwgraph # Audio Patchbay
      scrcpy # Android Remote Control
      seahorse # Encryption Key Manager
      sidequest # Meta Quest Sideloading
      vlc # Media Player
      xournalpp # Note-Taking
      yaak # API Client

      # Gaming Applications
      heroic # Multiplatform Game Launcher
      itch # Indie Game Launcher
      osu-lazer-bin # Rhythm Game
      prismlauncher # Minecraft Launcher
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
      templates = null;
      publicShare = null;
    };

    mimeApps.enable = true;
  };

  systemd.user.services.mbsync.unitConfig.After = [ "sops-nix.service" ];

  services = {
    cliphist.enable = true; # Wayland Clipboard Manager
    network-manager-applet.enable = true; # NetworkManager System Tray Applet
    blueman-applet.enable = true; # Blueman System Tray Applet

    # Sandboxed App Distribution
    flatpak = {
      uninstallUnmanaged = true; # Avoid Accumulation

      packages = [
        "com.usebottles.bottles" # Wine Prefix Manager
        "com.wonderlandengine.editor" # 3D Web Engine
      ];
    };

    mpris-proxy.enable = true; # Bluetooth Media Controls
  };

  programs = {
    home-manager.enable = true; # Manage Itself
  };
}
