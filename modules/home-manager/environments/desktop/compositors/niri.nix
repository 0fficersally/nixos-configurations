# Scrollable-Tiling Wayland Compositor
{ config, lib, pkgs, self, rofi-tools, ... }: {
  options = {
    modules.environments.desktop.compositors.niri.enable = lib.mkEnableOption "the niri scrollable-tiling Wayland compositor";
  };

  config = lib.mkIf config.modules.environments.desktop.compositors.niri.enable {
    home.packages = [ pkgs.xwayland-satellite ]; # Rootless XWayland Integration

    programs.niri.settings = {
      outputs = {
        # Internal
        "eDP-1" = {
          variable-refresh-rate = true;
          scale = 1.5;
          focus-at-startup = true;
        };
      };

      environment.SDL_VIDEODRIVER = "wayland";
      xwayland-satellite.path = lib.getExe pkgs.xwayland-satellite;
      screenshot-path = "${config.xdg.userDirs.pictures}/Screenshots/Screenshot_%Y-%m-%d_%H-%M-%S.png";

      layer-rules = [
        {
          matches = [ { namespace = "^wpaperd"; } ];
          place-within-backdrop = true;
        }
      ];

      layout = {
        background-color = "transparent";
        default-column-width = { proportion = 1. / 2.; };

        preset-column-widths = [
          { proportion = 1. / 3.; }
          { proportion = 1. / 2.; }
          { proportion = 2. / 3.; }
        ];

        gaps = 8;

        border = with config.modules.appearance.colors.schemes.catppuccin.macchiato; {
          enable = true;
          width = 2;
          inactive.color = overlay0;
          active.color = sky;
          urgent.color = red;
        };

        focus-ring.enable = false;
      };

      prefer-no-csd = true; # Client-Side Decorations

      window-rules = [
        # Global
        {
          geometry-corner-radius = {
            top-left = 12.;
            top-right = 12.;
            bottom-left = 12.;
            bottom-right = 12.;
          };

          clip-to-geometry = true;
        }

        # Nextcloud Desktop Client
        {
          matches = [ { app-id = "^com\\.nextcloud\\.desktopclient\\.nextcloud$"; } ];
          open-floating = true;
        }

        # Firefox Picture in Picture
        {
          matches = [ { app-id = "^(firefox|floorp)$"; title = "^Picture-in-Picture$"; } ];
          open-floating = true;
        }
      ];

      cursor = {
        theme = config.home.pointerCursor.name;
        size = config.home.pointerCursor.size;
        hide-after-inactive-ms = 5000; # 5 Seconds
      };

      input.keyboard = {
        xkb.layout = "be";
        numlock = true;
      };

      binds = let
        swayosd-client = lib.getExe' pkgs.swayosd "swayosd-client";
        kitty = lib.getExe pkgs.kitty;
      in with config.lib.niri.actions; {
        # Input Management
        "Mod+Escape".action = toggle-keyboard-shortcuts-inhibit;
        "Caps_Lock".action.spawn = [ swayosd-client "--caps-lock" ]; # Caps Lock Indicator (Broken)

        # Session Management
        "Mod+Alt+L" = { action.spawn = lib.getExe pkgs.swaylock; hotkey-overlay.title = "Lock Screen"; };
        "Mod+Shift+P".action = power-off-monitors;
        "Mod+Shift+E".action = quit;

        # Screen Brightness
        "XF86MonBrightnessDown" = { action.spawn = [ swayosd-client "--brightness" "-10" ]; allow-when-locked = true; };
        "XF86MonBrightnessUp" = { action.spawn = [ swayosd-client "--brightness" "+10" ]; allow-when-locked = true; };

        # Audio Controls
        "XF86AudioMute" = { action.spawn = [ swayosd-client "--output-volume" "mute-toggle" ]; allow-when-locked = true; };
        "XF86AudioLowerVolume" = { action.spawn = [ swayosd-client "--output-volume" "-5" ]; allow-when-locked = true; };
        "XF86AudioRaiseVolume" = { action.spawn = [ swayosd-client "--output-volume" "+5" ]; allow-when-locked = true; };
        "XF86AudioMicMute" = { action.spawn = [ swayosd-client "--input-volume" "mute-toggle" ]; allow-when-locked = true; };
        "XF86AudioPrev" = { action.spawn = [ swayosd-client "--playerctl" "previous" ]; allow-when-locked = true; };
        "XF86AudioPlay" = { action.spawn = [ swayosd-client "--playerctl" "play-pause" ]; allow-when-locked = true; };
        "XF86AudioStop" = { action.spawn = [ swayosd-client "--playerctl" "stop" ]; allow-when-locked = true; };
        "XF86AudioNext" = { action.spawn = [ swayosd-client "--playerctl" "next" ]; allow-when-locked = true; };

        # Screen Capturing ([Workaround](https://github.com/sodiboo/niri-flake/issues/944))
        "Print".action.screenshot-screen = [ { write-to-disk = false; } ]; # Active Display -> Clipboard
        "Shift+Print".action.screenshot-screen = []; # Active Display -> Disk
        "Alt+Print".action.screenshot-window = [ { write-to-disk = false; } ]; # Focused Window -> Clipboard
        "Shift+Alt+Print".action.screenshot-window = []; # Focused Window -> Disk
        "Ctrl+Print".action.screenshot = []; # Selection Menu

        # Directional Display Navigation
        "Mod+Shift+H".action = focus-monitor-left;
        "Mod+Shift+Left".action = focus-monitor-left;
        "Mod+Shift+J".action = focus-monitor-down;
        "Mod+Shift+Down".action = focus-monitor-down;
        "Mod+Shift+K".action = focus-monitor-up;
        "Mod+Shift+Up".action = focus-monitor-up;
        "Mod+Shift+L".action = focus-monitor-right;
        "Mod+Shift+Right".action = focus-monitor-right;

        # Absolute Workspace Navigation
        "Mod+Ampersand".action.focus-workspace = 1;
        "Mod+Eacute".action.focus-workspace = 2;
        "Mod+Quotedbl".action.focus-workspace = 3;
        "Mod+Apostrophe".action.focus-workspace = 4;
        "Mod+Parenleft".action.focus-workspace = 5;
        "Mod+Section".action.focus-workspace = 6;
        "Mod+Egrave".action.focus-workspace = 7;
        "Mod+Exclam".action.focus-workspace = 8;
        "Mod+Ccedilla".action.focus-workspace = 9;
        "Mod+Agrave".action.focus-workspace = 10;

        # Relative Workspace Navigation
        "Mod+U".action = focus-workspace-down;
        "Mod+Tab".action = focus-workspace-down;
        "Mod+Page_Down".action = focus-workspace-down;
        "Mod+WheelScrollDown" = { action = focus-workspace-down; cooldown-ms = 150; };
        "Mod+I".action = focus-workspace-up;
        "Mod+Shift+Tab".action = focus-workspace-up;
        "Mod+Page_Up".action = focus-workspace-up;
        "Mod+WheelScrollUp" = { action = focus-workspace-up; cooldown-ms = 150; };
        "Mod+Ctrl+Tab".action = focus-workspace-previous; # Back and Forth

        # Workspace Arrangement
        "Mod+Shift+U".action = move-workspace-down;
        "Mod+Shift+Page_Down".action = move-workspace-down;
        "Mod+Shift+I".action = move-workspace-up;
        "Mod+Shift+Page_Up".action = move-workspace-up;

        # Column and Window Management
        "Mod+F".action = maximize-column;
        "Mod+C".action = center-column;
        "Mod+Ctrl+C".action = center-visible-columns;
        "Mod+W".action = toggle-column-tabbed-display;
        "Mod+V".action = toggle-window-floating;
        "Mod+Shift+F".action = fullscreen-window;
        "Mod+Q" = { action = close-window; repeat = false; };

        # Column Width
        "Mod+R".action = switch-preset-column-width;
        "Mod+Ctrl+F".action = expand-column-to-available-width;
        "Mod+Equal".action.set-column-width = "+10%";
        "Mod+Minus".action.set-column-width = "-10%";

        # Window Height
        "Mod+Shift+R".action = switch-preset-window-height;
        "Mod+Ctrl+R".action = reset-window-height;
        "Mod+Shift+Equal".action.set-window-height = "+10%";
        "Mod+Shift+Minus".action.set-window-height = "-10%";

        "Mod+Shift+V".action = switch-focus-between-floating-and-tiling; # Toggle Arrangement Type Focus

        # Column and Window Navigation
        "Mod+H".action = focus-column-left;
        "Mod+Left".action = focus-column-left;
        "Mod+Shift+WheelScrollUp".action = focus-column-left;
        "Mod+WheelScrollLeft".action = focus-column-left;
        "Mod+J".action = focus-window-down;
        "Mod+Down".action = focus-window-down;
        "Mod+K".action = focus-window-up;
        "Mod+Up".action = focus-window-up;
        "Mod+L".action = focus-column-right;
        "Mod+Right".action = focus-column-right;
        "Mod+Shift+WheelScrollDown".action = focus-column-right;
        "Mod+WheelScrollRight".action = focus-column-right;
        "Mod+Home".action = focus-column-first;
        "Mod+End".action = focus-column-last;

        # Column and Window Arrangement
        "Mod+Ctrl+H".action = move-column-left;
        "Mod+Ctrl+Left".action = move-column-left;
        "Mod+Ctrl+Shift+WheelScrollUp".action = move-column-left;
        "Mod+Ctrl+WheelScrollLeft".action = move-column-left;
        "Mod+Ctrl+J".action = move-window-down;
        "Mod+Ctrl+Down".action = move-window-down;
        "Mod+Ctrl+K".action = move-window-up;
        "Mod+Ctrl+Up".action = move-window-up;
        "Mod+Ctrl+L".action = move-column-right;
        "Mod+Ctrl+Right".action = move-column-right;
        "Mod+Ctrl+Shift+WheelScrollDown".action = move-column-right;
        "Mod+Ctrl+WheelScrollRight".action = move-column-right;
        "Mod+Ctrl+Home".action = move-column-to-first;
        "Mod+Ctrl+End".action = move-column-to-last;

        # Consuming or Expelling Columns and Windows
        "Mod+BracketLeft".action = consume-or-expel-window-left;
        "Mod+BracketRight".action = consume-or-expel-window-right;
        "Mod+Comma".action = consume-window-into-column;
        "Mod+Period".action = expel-window-from-column;

        # Absolute per Workspace Column Arrangement ([Workaround](https://github.com/sodiboo/niri-flake/issues/1018))
        "Mod+Shift+Ampersand".action.move-window-to-workspace = 1;
        "Mod+Shift+Eacute".action.move-window-to-workspace = 2;
        "Mod+Shift+Quotedbl".action.move-window-to-workspace = 3;
        "Mod+Shift+Apostrophe".action.move-window-to-workspace = 4;
        "Mod+Shift+Parenleft".action.move-window-to-workspace = 5;
        "Mod+Shift+Section".action.move-window-to-workspace = 6;
        "Mod+Shift+Egrave".action.move-window-to-workspace = 7;
        "Mod+Shift+Exclam".action.move-window-to-workspace = 8;
        "Mod+Shift+Ccedilla".action.move-window-to-workspace = 9;
        "Mod+Shift+Agrave".action.move-window-to-workspace = 10;

        # Relative per Workspace Column Arrangement
        "Mod+Ctrl+U".action = move-column-to-workspace-down;
        "Mod+Ctrl+Page_Down".action = move-column-to-workspace-down;
        "Mod+Ctrl+WheelScrollDown" = { action = move-column-to-workspace-down; cooldown-ms = 150; };
        "Mod+Ctrl+I".action = move-column-to-workspace-up;
        "Mod+Ctrl+Page_Up".action = move-column-to-workspace-up;
        "Mod+Ctrl+WheelScrollUp" = { action = move-column-to-workspace-up; cooldown-ms = 150; };
        
        # Per Display Column Arrangement
        "Mod+Shift+Ctrl+H".action = move-column-to-monitor-left;
        "Mod+Shift+Ctrl+Left".action = move-column-to-monitor-left;
        "Mod+Shift+Ctrl+J".action = move-column-to-monitor-down;
        "Mod+Shift+Ctrl+Down".action = move-column-to-monitor-down;
        "Mod+Shift+Ctrl+K".action = move-column-to-monitor-up;
        "Mod+Shift+Ctrl+Up".action = move-column-to-monitor-up;
        "Mod+Shift+Ctrl+L".action = move-column-to-monitor-right;
        "Mod+Shift+Ctrl+Right".action = move-column-to-monitor-right;

        # Toggleable Overviews
        "Mod+O" = { action = toggle-overview; repeat = false; };
        "Mod+Less".action = show-hotkey-overlay;

        # Toggleable Menus
        "Mod+Space" = {
          action.spawn-sh = "pgrep rofi >/dev/null 2>&1 && killall rofi || ${lib.getExe pkgs.rofi} -show combi";
          hotkey-overlay.title = "Open Application Launcher";
        };
        "Mod+F1" = {
          action.spawn = lib.getExe rofi-tools.packages.${pkgs.stdenv.hostPlatform.system}.rofi-cliphist;
          hotkey-overlay.title = "Open Clipboard Manager";
        };
        "Mod+F2" = {
          action.spawn = lib.getExe pkgs.rofimoji;
          hotkey-overlay.title = "Open Character Picker";
        };
        "Mod+F3" = {
          action.spawn = lib.getExe pkgs.rofi-rbw;
          hotkey-overlay.title = "Open Password Manager";
        };
        "Mod+Menu" = {
          action.spawn = [ (lib.getExe' pkgs.swaynotificationcenter "swaync-client") "-t" "-sw" ];
          hotkey-overlay.title = "Toggle Notification Centre";
        };

        # Applications
        "XF86Calculator" = {
          action.spawn = lib.getExe pkgs.qalculate-gtk;
          hotkey-overlay.title = "Open Multipurpose Calculator";
        };
        "Mod+Return" = {
          action.spawn = kitty;
          hotkey-overlay.title = "Launch Terminal Emulator";
        };
        "Mod+Alt+R" = {
          action.spawn = [ kitty "--hold" (lib.getExe pkgs.btop) ];
          hotkey-overlay.title = "Launch Resource Monitor";
        };
        "Mod+Alt+F" = {
          action.spawn = lib.getExe pkgs.nemo;
          hotkey-overlay.title = "Launch File Manager";
        };
        "Mod+Alt+Shift+F" = {
          action.spawn = lib.getExe pkgs.localsend;
          hotkey-overlay.title = "Open LAN File-Sharing Program";
        };
        "Mod+Alt+D" = {
          action.spawn = lib.getExe pkgs.vscodium;
          hotkey-overlay.title = "Launch Development Environment";
        };
        "Mod+Alt+Shift+D" = {
          action.spawn = [ kitty "--hold" (lib.getExe pkgs.podman-tui) ];
          hotkey-overlay.title = "Launch Container Dashboard";
        };
        "Mod+Alt+B" = {
          action.spawn = lib.getExe pkgs.floorp-bin;
          hotkey-overlay.title = "Launch Web Browser (Gecko)";
        };
        "Mod+Alt+Shift+B" = {
          action.spawn = lib.getExe pkgs.ungoogled-chromium;
          hotkey-overlay.title = "Launch Web Browser (Blink)";
        };
        "Mod+Alt+N" = {
          action.spawn = lib.getExe pkgs.obsidian;
          hotkey-overlay.title = "Launch PKB Suite";
        };
        "Mod+Alt+P" = {
          action.spawn = lib.getExe pkgs.thunderbird;
          hotkey-overlay.title = "Launch PIM Suite";
        };
        "Mod+Alt+M" = {
          action.spawn = lib.getExe pkgs.vesktop;
          hotkey-overlay.title = "Launch Messaging Platform";
        };
      };

      hotkey-overlay.skip-at-startup = true;

      spawn-at-startup = [
        { argv = [ (lib.getExe pkgs.wpaperd) "--daemon" ]; } # Wallpaper Daemon
        { argv = [ (lib.getExe pkgs.waybar) ]; } # Status Bar
        { argv = [ (lib.getExe' pkgs.swayosd "swayosd-server") ]; } # Hotkey Action OSD
        { argv = [ (lib.getExe' pkgs.wl-clipboard "wl-paste") "--watch" (lib.getExe pkgs.cliphist) "store" ]; } # Clipboard Manager
        { argv = [ (lib.getExe pkgs.kitty) "--hold" (lib.getExe pkgs.fastfetch) ]; } # System Information Fetcher
      ];
    };

    # Preferred Desktop Portals ([Workaround](https://github.com/yalter/niri/issues/702))
    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [ xdg-desktop-portal-gnome xdg-desktop-portal-gtk ];

      config.niri = {
        "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
        "org.freedesktop.impl.portal.RemoteDesktop" = [ "gnome" ];
        "org.freedesktop.impl.portal.ScreenCast" = [ "gnome" ];
        "org.freedesktop.impl.portal.Screenshot" = [ "gnome" ];
      };
    };
  };
}
