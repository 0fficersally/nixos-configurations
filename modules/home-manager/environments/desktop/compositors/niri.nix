# Scrollable-Tiling Wayland Compositor
{ config, lib, pkgs, ... }: {
  options = {
    modules.environments.desktop.compositors.niri.enable = lib.mkEnableOption "the niri scrollable-tiling Wayland compositor";
  };

  config = lib.mkIf config.modules.environments.desktop.compositors.niri.enable {
    home.packages = with pkgs; [ xwayland-satellite ]; # Rootless XWayland Integration

    programs.niri.settings = {
      outputs = {
        # Internal Display
        "eDP-2" = {
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
          matches = [ { namespace = "^noctalia-wallpaper*"; } ];
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

        # Windscribe
        {
          matches = [ { app-id = "^Windscribe$"; } ];
          open-floating = true;
        }

        # Nextcloud Desktop Client
        {
          matches = [ { app-id = "^com\\.nextcloud\\.desktopclient\\.nextcloud$"; } ];
          open-floating = true;
        }

        # Firefox Picture in Picture
        {
          matches = [ {
            app-id = "^(firefox|floorp)$";
            title = "^Picture-in-Picture$";
          } ];

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
        noctalia = command: [ (lib.getExe pkgs.noctalia-shell) "ipc" "call" ] ++ (lib.splitString " " command);
        kitty = lib.getExe pkgs.kitty;
      in with config.lib.niri.actions; {
        # Audio Controls

        "XF86AudioMute" = {
          action.spawn = noctalia "volume muteOutput";
          allow-when-locked = true;
        };

        "XF86AudioLowerVolume" = {
          action.spawn = noctalia "volume decrease";
          allow-when-locked = true;
        };

        "XF86AudioRaiseVolume" = {
          action.spawn = noctalia "volume increase";
          allow-when-locked = true;
        };

        "XF86AudioMicMute" = {
          action.spawn = noctalia "volume muteInput";
          allow-when-locked = true;
        };

        # Media Controls

        "XF86AudioPrev" = {
          action.spawn = noctalia "media previous";
          allow-when-locked = true;
        };

        "XF86AudioPlay" = {
          action.spawn = noctalia "media playPause";
          allow-when-locked = true;
        };

        "XF86AudioNext" = {
          action.spawn = noctalia "media next";
          allow-when-locked = true;
        };

        # Screen Brightness

        "XF86MonBrightnessDown" = {
          action.spawn = noctalia "brightness decrease";
          allow-when-locked = true;
        };

        "XF86MonBrightnessUp" = {
          action.spawn = noctalia "brightness increase";
          allow-when-locked = true;
        };

        # Screen Capturing ([Workaround](https://github.com/sodiboo/niri-flake/issues/944))

        "Print".action.screenshot-screen = [ { write-to-disk = false; } ]; # Active Display -> Clipboard
        "Shift+Print".action.screenshot-screen = [ ]; # Active Display -> Disk
        "Alt+Print".action.screenshot-window = [ { write-to-disk = false; } ]; # Focused Window -> Clipboard
        "Shift+Alt+Print".action.screenshot-window = [ ]; # Focused Window -> Disk
        "Ctrl+Print".action.screenshot = [ ]; # Selection Menu

        # Input Management

        "XF86Tools".action = toggle-keyboard-shortcuts-inhibit;

        # Session Management

        "Mod+Alt+Escape" = {
          action.spawn = noctalia "lockScreen lock";
          hotkey-overlay.title = "Lock Screen";
        };

        "Mod+Shift+E".action = quit;
        "Mod+Shift+P".action = power-off-monitors;

        # Directional Display Navigation

        "Mod+Shift+H".action = focus-monitor-left;
        "Mod+Shift+J".action = focus-monitor-down;
        "Mod+Shift+K".action = focus-monitor-up;
        "Mod+Shift+L".action = focus-monitor-right;
        "Mod+Shift+Up".action = focus-monitor-up;
        "Mod+Shift+Left".action = focus-monitor-left;
        "Mod+Shift+Down".action = focus-monitor-down;
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

        "Mod+Tab".action = focus-workspace-down;
        "Mod+U".action = focus-workspace-down;
        "Mod+Page_Down".action = focus-workspace-down;

        "Mod+WheelScrollDown" = {
          action = focus-workspace-down;
          cooldown-ms = 150;
        };

        "Mod+Shift+Tab".action = focus-workspace-up;
        "Mod+I".action = focus-workspace-up;
        "Mod+Page_Up".action = focus-workspace-up;

        "Mod+WheelScrollUp" = {
          action = focus-workspace-up;
          cooldown-ms = 150;
        };

        "Mod+Ctrl+Tab".action = focus-workspace-previous; # Back and Forth

        # Workspace Arrangement

        "Mod+Shift+U".action = move-workspace-down;
        "Mod+Shift+I".action = move-workspace-up;
        "Mod+Shift+Page_Down".action = move-workspace-down;
        "Mod+Shift+Page_Up".action = move-workspace-up;

        # Column and Window Management

        "Mod+Q" = {
          action = close-window;
          repeat = false;
        };

        "Mod+F".action = maximize-column;
        "Mod+Shift+F".action = fullscreen-window;
        "Mod+W".action = toggle-column-tabbed-display;
        "Mod+C".action = center-column;
        "Mod+Ctrl+C".action = center-visible-columns;
        "Mod+V".action = toggle-window-floating;

        # Column Width

        "Mod+R".action = switch-preset-column-width;
        "Mod+Ctrl+F".action = expand-column-to-available-width;
        "Mod+Minus".action.set-column-width = "-10%";
        "Mod+Equal".action.set-column-width = "+10%";

        # Window Height

        "Mod+Shift+R".action = switch-preset-window-height;
        "Mod+Ctrl+R".action = reset-window-height;
        "Mod+Shift+Minus".action.set-window-height = "-10%";
        "Mod+Shift+Equal".action.set-window-height = "+10%";

        # Toggle Arrangement Type Focus

        "Mod+Shift+V".action = switch-focus-between-floating-and-tiling;

        # Column and Window Navigation

        "Mod+H".action = focus-column-left;
        "Mod+J".action = focus-window-down;
        "Mod+K".action = focus-window-up;
        "Mod+L".action = focus-column-right;
        "Mod+Up".action = focus-window-up;
        "Mod+Left".action = focus-column-left;
        "Mod+Home".action = focus-column-first;
        "Mod+Down".action = focus-window-down;
        "Mod+Right".action = focus-column-right;
        "Mod+End".action = focus-column-last;
        "Mod+WheelScrollLeft".action = focus-column-left;
        "Mod+WheelScrollRight".action = focus-column-right;
        "Mod+Shift+WheelScrollUp".action = focus-column-left;
        "Mod+Shift+WheelScrollDown".action = focus-column-right;

        # Column and Window Arrangement

        "Mod+Ctrl+H".action = move-column-left;
        "Mod+Ctrl+J".action = move-window-down;
        "Mod+Ctrl+K".action = move-window-up;
        "Mod+Ctrl+L".action = move-column-right;
        "Mod+Ctrl+Up".action = move-window-up;
        "Mod+Ctrl+Left".action = move-column-left;
        "Mod+Ctrl+Home".action = move-column-to-first;
        "Mod+Ctrl+Down".action = move-window-down;
        "Mod+Ctrl+Right".action = move-column-right;
        "Mod+Ctrl+End".action = move-column-to-last;
        "Mod+Ctrl+WheelScrollLeft".action = move-column-left;
        "Mod+Ctrl+WheelScrollRight".action = move-column-right;
        "Mod+Ctrl+Shift+WheelScrollUp".action = move-column-left;
        "Mod+Ctrl+Shift+WheelScrollDown".action = move-column-right;

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

        "Mod+Ctrl+WheelScrollDown" = {
          action = move-column-to-workspace-down;
          cooldown-ms = 150;
        };

        "Mod+Ctrl+I".action = move-column-to-workspace-up;
        "Mod+Ctrl+Page_Up".action = move-column-to-workspace-up;

        "Mod+Ctrl+WheelScrollUp" = {
          action = move-column-to-workspace-up;
          cooldown-ms = 150;
        };
        
        # Per Display Column Arrangement

        "Mod+Shift+Ctrl+H".action = move-column-to-monitor-left;
        "Mod+Shift+Ctrl+J".action = move-column-to-monitor-down;
        "Mod+Shift+Ctrl+K".action = move-column-to-monitor-up;
        "Mod+Shift+Ctrl+L".action = move-column-to-monitor-right;
        "Mod+Shift+Ctrl+Up".action = move-column-to-monitor-up;
        "Mod+Shift+Ctrl+Left".action = move-column-to-monitor-left;
        "Mod+Shift+Ctrl+Down".action = move-column-to-monitor-down;
        "Mod+Shift+Ctrl+Right".action = move-column-to-monitor-right;

        # Toggleable Overviews

        "Mod+O" = {
          action = toggle-overview;
          repeat = false;
        };

        "Mod+Less".action = show-hotkey-overlay;

        # Toggleable Menus

        "Mod+Escape" = {
          action.spawn = noctalia "sessionMenu toggle";
          hotkey-overlay.title = "Toggle Session Menu";
        };

        "Mod+F1" = {
          action.spawn = noctalia "launcher clipboard";
          hotkey-overlay.title = "Toggle Clipboard Menu";
        };

        "Mod+F2" = {
          action.spawn = noctalia "launcher emoji";
          hotkey-overlay.title = "Toggle Emoji Picker";
        };

        "Mod+Space" = {
          action.spawn = noctalia "launcher toggle";
          hotkey-overlay.title = "Toggle Launcher";
        };

        "Mod+Alt+Space" = {
          action.spawn = noctalia "notifications toggleHistory";
          hotkey-overlay.title = "Toggle Notification Centre";
        };

        # Applications

        "XF86Calculator" = {
          action.spawn = lib.getExe pkgs.qalculate-qt;
          hotkey-overlay.title = "Open Multipurpose Calculator";
        };

        "Mod+Alt+R" = {
          action.spawn = [ kitty "--hold" (lib.getExe pkgs.btop) ];
          hotkey-overlay.title = "Launch Resource Monitor";
        };

        "Mod+Alt+P" = {
          action.spawn = lib.getExe pkgs.thunderbird;
          hotkey-overlay.title = "Launch PIM Suite";
        };

        "Mod+Alt+D" = {
          action.spawn = lib.getExe pkgs.vscodium;
          hotkey-overlay.title = "Launch Development Environment";
        };

        "Mod+Alt+Shift+D" = {
          action.spawn = [ kitty "--hold" (lib.getExe pkgs.podman-tui) ];
          hotkey-overlay.title = "Launch Container Dashboard";
        };

        "Mod+Alt+F" = {
          action.spawn = lib.getExe' pkgs.kdePackages.dolphin "dolphin";
          hotkey-overlay.title = "Launch File Manager";
        };

        "Mod+Alt+Shift+F" = {
          action.spawn = lib.getExe pkgs.localsend;
          hotkey-overlay.title = "Open LAN File-Sharing Program";
        };

        "Mod+Alt+M" = {
          action.spawn = lib.getExe pkgs.vesktop;
          hotkey-overlay.title = "Launch Messaging Platform";
        };

        "Mod+Return" = {
          action.spawn = kitty;
          hotkey-overlay.title = "Launch Terminal Emulator";
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
      };

      hotkey-overlay.skip-at-startup = true;

      spawn-at-startup = [
        { argv = [ (lib.getExe pkgs.noctalia-shell) ]; } # Desktop Shell
        { argv = [ (lib.getExe pkgs.kitty) "--hold" (lib.getExe pkgs.fastfetch) ]; } # System Information Fetcher
      ];
    };

    # Preferred Desktop Portals ([Workaround](https://github.com/yalter/niri/issues/702))
    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [ kdePackages.xdg-desktop-portal-kde xdg-desktop-portal-gnome xdg-desktop-portal-gtk ];

      config.niri = {
        "org.freedesktop.impl.portal.FileChooser" = [ "kde" ];
        "org.freedesktop.impl.portal.RemoteDesktop" = [ "gnome" ];
        "org.freedesktop.impl.portal.ScreenCast" = [ "gnome" ];
        "org.freedesktop.impl.portal.Screenshot" = [ "gnome" ];
      };
    };
  };
}
