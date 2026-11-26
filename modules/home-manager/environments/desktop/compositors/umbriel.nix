# Wayland Compositor
{ config, lib, ... }: {
  options = {
    modules.environments.desktop.compositors.umbriel.enable = lib.mkEnableOption "the Umbriel Wayland compositor";
  };

  config = lib.mkIf config.modules.environments.desktop.compositors.umbriel.enable {
    programs.umbriel = {
      enable = true;

      settings = {
        include = {
          files = [ ];
          optional.files = [ ];
        };

        general = {
          xwayland_native_resolution = true;
          show_cheatsheet = false;
        };


        output = {
          # Internal Display
          eDP-2 = {
            vrr = "enabled";
            scale = 1.5;
            focus_at_startup = true;
          };
        };

        appearance.blur.radius = 3;
        input.keyboard.numlock_toggle = true;

        keybinds = {
          "Mod+Return" = {
            action = "spawn kitty";
            repeat = false;
          };

          "Mod+Q" = {
            action = "window-close";
            repeat = false;
          };

          "Mod+Escape" = "session-quit";

          "Mod+Shift+Escape" = {
            action = "shortcuts-inhibit-toggle";
            allow_when_inhibited = true;
            repeat = false;
          };

          "Mod+Left" = "window-focus-left";
          "Mod+Down" = "window-focus-down";
          "Mod+Up" = "window-focus-up";
          "Mod+Right" = "window-focus-right";
          "Mod+H" = "window-focus-left";
          "Mod+J" = "window-focus-down";
          "Mod+K" = "window-focus-up";
          "Mod+L" = "window-focus-right";
          "Mod+F1" = "window-focus-next";
          "Mod+Shift+Left" = "column-move-left";
          "Mod+Shift+Down" = "window-move-down";
          "Mod+Shift+Up" = "window-move-up";
          "Mod+Shift+Right" = "column-move-right";

          "Mod+T" = {
            action = "window-toggle-floating";
            repeat = false;
          };

          "Mod+Shift+T" = {
            action = "window-focus-switch-floating";
            repeat = false;
          };

          "Mod+P" = {
            action = "window-toggle-pinned";
            repeat = false;
          };

          "Mod+M" = {
            action = "window-toggle-maximize-to-edges";
            repeat = false;
          };

          "Mod+F" = {
            action = "window-toggle-fullscreen";
            repeat = false;
          };

          "Mod+Ctrl+F" = {
            action = "window-toggle-maximize";
            repeat = false;
          };

          "Mod+R" = "window-cycle-primary-extent";
          "Mod+Shift+R" = "window-cycle-primary-extent-back";
          "Mod+Minus" = "window-modify-primary-extent -0.02";
          "Mod+Equal" = "window-modify-primary-extent +0.02";
          "Mod+Ctrl+Minus" = "window-modify-secondary-extent -0.02";
          "Mod+Ctrl+Equal" = "window-modify-secondary-extent +0.02";
          "Mod+Comma" = "window-consume-left";
          "Mod+Period" = "window-consume-right";
          "Mod+Ctrl+Comma" = "window-consume-from-left";
          "Mod+Ctrl+Period" = "window-consume-from-right";

          "Mod+W" = {
            action = "column-toggle-tabbed";
            repeat = false;
          };

          "Mod+Alt+Right" = "column-focus-tab-next";
          "Mod+Alt+Left" = "column-focus-tab-previous";
          "Mod+WheelUp" = "window-focus-left";
          "Mod+WheelDown" = "window-focus-right";

          "Mod+O" = {
            action = "overview-toggle";
            repeat = false;
          };

          "Mod+1" = "workspace-switch 1";
          "Mod+2" = "workspace-switch 2";
          "Mod+3" = "workspace-switch 3";
          "Mod+4" = "workspace-switch 4";
          "Mod+5" = "workspace-switch 5";
          "Mod+6" = "workspace-switch 6";
          "Mod+7" = "workspace-switch 7";
          "Mod+8" = "workspace-switch 8";
          "Mod+9" = "workspace-switch 9";
          "Mod+Shift+1" = "window-move-to-workspace 1";
          "Mod+Shift+2" = "window-move-to-workspace 2";
          "Mod+Shift+3" = "window-move-to-workspace 3";
          "Mod+Shift+4" = "window-move-to-workspace 4";
          "Mod+Shift+5" = "window-move-to-workspace 5";
          "Mod+Shift+6" = "window-move-to-workspace 6";
          "Mod+Shift+7" = "window-move-to-workspace 7";
          "Mod+Shift+8" = "window-move-to-workspace 8";
          "Mod+Shift+9" = "window-move-to-workspace 9";

          "Mod+Shift+Space" = {
            action = "window-move-to-scratchpad";
            repeat = false;
          };

          "Mod+Space" = "scratchpad-toggle";

          "Mod+Ctrl+Space" = {
            action = "window-restore-from-scratchpad";
            repeat = false;
          };

          "Mod+Tab" = "scratchpad-focus-next";
        };

        layout = {
          extent_presets = [ 0.333 0.5 0.667 ];
          stacking = { };
          scrolling.default_extent_fraction = 0.5;
        };

        window_rule = [
          {
            blur = true;
          }

          {
            match.title = "^(Picture-in-Picture|Picture in picture)$";
            default_floating = true;
            default_maximize = false;

            default_position = {
              x = 20;
              y = 20;
              anchor = "bottom_right";
            };
          }

          {
            match.title = "^notificationtoasts_.+_desktop";

            default_position = {
              x = 0;
              y = 0;
              anchor = "bottom_right";
            };

            default_focused = false;
            default_pinned = true;
          }
        ];

        hot_corners.top_left = {
          enabled = true;
          delay_ms = 500;
          action = "overview-open";
        };
      };
    };
  };
}
