# Tiling Wayland Compositor
{ config, lib, pkgs, self, rofi-tools, ... }: {
  options = {
    modules.environments.desktop.compositors.sway.enable = lib.mkEnableOption "the Sway tiling Wayland compositor";
  };

  config = lib.mkIf config.modules.environments.desktop.compositors.sway.enable {
    nixpkgs.overlays = [ (final: prev: {
      scripts = (prev.scripts or {}) // {
        # Wayland Screenshot Utility
        screenshot = final.writeShellApplication {
          name = "screenshot";
          runtimeInputs = with final; [ grim jq slurp ];
          text = builtins.readFile (builtins.toPath "${self}/scripts/screenshot.sh");
        };
      };
    }) ];

    wayland.windowManager.sway = {
      enable = true;
      package = null; # Use NixOS Module

      config = rec {
        output = {
          # Internal
          "eDP-1" = {
            mode = "2560x1440@240Hz";
            scale = "1.5";
          };
        };

        bars = [ { command = lib.getExe pkgs.waybar; } ]; # Status Bar

        gaps = {
          outer = 8;
          inner = 8;
        };

        window = {
          titlebar = false;
          border = 2;
        };

        floating = {
          titlebar = false;
          border = 2;
        };

        input."*".xkb_layout = "be"; # Keyboard
        modifier = "Mod4"; # Super Key
        terminal = lib.getExe pkgs.kitty;
        menu = "pgrep rofi >/dev/null 2>&1 && killall rofi || ${lib.getExe pkgs.rofi} -show combi"; # Application Launcher

        keybindings = let
          swayosd-client = lib.getExe' pkgs.swayosd "swayosd-client";
          screenshot = lib.getExe pkgs.scripts.screenshot;
          kitty = lib.getExe pkgs.kitty;
        in lib.mkOptionDefault {
          # Screen Brightness
          "XF86MonBrightnessDown" = "exec ${swayosd-client} --brightness -10";
          "XF86MonBrightnessUp" = "exec ${swayosd-client} --brightness +10";

          # Audio Controls
          "XF86AudioMute" = "exec ${swayosd-client} --output-volume mute-toggle";
          "XF86AudioLowerVolume" = "exec ${swayosd-client} --output-volume -5";
          "XF86AudioRaiseVolume" = "exec ${swayosd-client} --output-volume 5";
          "XF86AudioMicMute" = "exec ${swayosd-client} --input-volume mute-toggle";
          "XF86AudioPrev" = "exec ${swayosd-client} --playerctl previous";
          "XF86AudioPlay" = "exec ${swayosd-client} --playerctl play-pause";
          "XF86AudioStop" = "exec ${swayosd-client} --playerctl stop";
          "XF86AudioNext" = "exec ${swayosd-client} --playerctl next";

          # Screen Capturing
          "Print" = "exec ${screenshot} full"; # Active Display -> Clipboard
          "Shift+Print" = "exec ${screenshot} -s full"; # Active Display -> Disk
          "Mod1+Print" = "exec ${screenshot} window"; # Focused Window -> Clipboard
          "Shift+Mod1+Print" = "exec ${screenshot} -s window"; # Focused Window -> Disk
          "Ctrl+Print" = "exec ${screenshot} region"; # Selected Region -> Clipboard
          "Shift+Ctrl+Print" = "exec ${screenshot} -s region"; # Selected Region -> Disk

          "--release Caps_Lock" = "exec ${swayosd-client} --caps-lock"; # Caps Lock Indicator

          # Absolute Workspace Navigation
          "${modifier}+ampersand" = "workspace number 1";
          "${modifier}+eacute" = "workspace number 2";
          "${modifier}+quotedbl" = "workspace number 3";
          "${modifier}+apostrophe" = "workspace number 4";
          "${modifier}+parenleft" = "workspace number 5";
          "${modifier}+section" = "workspace number 6";
          "${modifier}+egrave" = "workspace number 7";
          "${modifier}+exclam" = "workspace number 8";
          "${modifier}+ccedilla" = "workspace number 9";
          "${modifier}+agrave" = "workspace number 10";

          # Relative Workspace Navigation
          "${modifier}+Tab" = "workspace next";
          "${modifier}+Shift+Tab" = "workspace prev";
          "${modifier}+Ctrl+Tab" = "workspace back_and_forth";

          # Windows
          "${modifier}+Shift+v" = "focus mode_toggle"; # Swap Tiling or Floating Area Focus
          "${modifier}+q" = "kill"; # Close Focused Window
          "${modifier}+Shift+q" = "[workspace=__focused__] kill"; # Close All Windows

          # Moving Windows to Workspaces
          "${modifier}+Shift+ampersand" = "move container to workspace number 1";
          "${modifier}+Shift+eacute" = "move container to workspace number 2";
          "${modifier}+Shift+quotedbl" = "move container to workspace number 3";
          "${modifier}+Shift+apostrophe" = "move container to workspace number 4";
          "${modifier}+Shift+parenleft" = "move container to workspace number 5";
          "${modifier}+Shift+section" = "move container to workspace number 6";
          "${modifier}+Shift+egrave" = "move container to workspace number 7";
          "${modifier}+Shift+exclam" = "move container to workspace number 8";
          "${modifier}+Shift+ccedilla" = "move container to workspace number 9";
          "${modifier}+Shift+agrave" = "move container to workspace number 10";

          # Toggleable Menus
          "${modifier}+d" = null; # Unset Default Menu
          "${modifier}+space" = "exec ${menu}"; # Application Launcher
          "${modifier}+F1" = "exec ${lib.getExe rofi-tools.packages.${pkgs.stdenv.hostPlatform.system}.rofi-cliphist}"; # Clipboard Manager
          "${modifier}+F2" = "exec ${lib.getExe pkgs.rofimoji}"; # Character Picker
          "${modifier}+F3" = "exec ${lib.getExe pkgs.rofi-rbw}"; # Password Manager
          "${modifier}+Menu" = "exec ${lib.getExe' pkgs.swaynotificationcenter "swaync-client"} -t -sw"; # Notification Centre

          # Applications
          "XF86Calculator" = "exec ${lib.getExe pkgs.qalculate-gtk}";
          "${modifier}+Mod1+r" = "exec ${kitty} --hold ${lib.getExe pkgs.btop}"; # Resource Monitor
          "${modifier}+Mod1+f" = "exec ${lib.getExe pkgs.nemo}"; # File Manager
          "${modifier}+Mod1+Shift+f" = "exec ${lib.getExe pkgs.localsend}"; # LAN File Sharing
          "${modifier}+Mod1+d" = "exec ${lib.getExe pkgs.vscodium}"; # Integrated Development Environment
          "${modifier}+Mod1+Shift+d" = "exec ${kitty} --hold ${lib.getExe pkgs.podman-tui}"; # Podman Dashboard
          "${modifier}+Mod1+b" = "exec ${lib.getExe pkgs.floorp-bin}"; # Web Browser (Gecko Engine)
          "${modifier}+Mod1+Shift+b" = "exec ${lib.getExe pkgs.ungoogled-chromium}"; # Web Browser (Blink Engine)
          "${modifier}+Mod1+n" = "exec ${lib.getExe pkgs.obsidian}"; # Personal Knowledge Base
          "${modifier}+Mod1+p" = "exec ${lib.getExe pkgs.thunderbird}"; # PIM Suite
          "${modifier}+Mod1+m" = "exec ${lib.getExe pkgs.vesktop}"; # Discord (Social Platform)
        };

        defaultWorkspace = "workspace number 1";

        startup = [
          { command = "${lib.getExe pkgs.wpaperd} --daemon"; } # Wallpaper Daemon
          { command = lib.getExe' pkgs.swayosd "swayosd-server"; } # Key Action Indicator
          { command = "${lib.getExe' pkgs.wl-clipboard "wl-paste"} --watch ${lib.getExe pkgs.cliphist} store"; } # Clipboard Manager
          { command = "${lib.getExe pkgs.kitty} --hold ${lib.getExe pkgs.fastfetch}"; } # System Information Fetcher
        ];
      };

      extraConfig = "corner_radius 12"; # SwayFX (Eye Candy)
      extraSessionCommands = "export SDL_VIDEODRIVER=wayland";
    };

    home.pointerCursor.sway.enable = true; # Mouse Pointer Customisation
  };
}
