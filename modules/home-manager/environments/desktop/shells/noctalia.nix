# Desktop Shell
{ config, lib, pkgs, ... }: {
  options = {
    modules.environments.desktop.shells.noctalia = lib.mkEnableOption "the Noctalia desktop shell";
  };

  config = lib.mkIf config.modules.environments.desktop.shells.noctalia {
    services.cliphist.enable = true; # Wayland Clipboard Manager

    programs = {
      noctalia = {
        enable = true;
      };

      # Wayland Compositors

      niri.settings = {
        layer-rules = [
          {
            matches = [ { namespace = "^noctalia-backdrop"; } ];
            place-within-backdrop = true;
          }
        ];

        window-rules = [
          # Noctalia Settings
          {
            matches = [ { app-id = "dev.noctalia.Noctalia"; } ];
            open-floating = true;
            default-column-width.fixed = 1080;
            default-window-height.fixed = 920;
          }
        ];

        binds = let noctalia = command: [ (lib.getExe pkgs.noctalia) "msg" ] ++ (lib.splitString " " command); in {
          # Audio Controls

          "XF86AudioMute" = {
            action.spawn = noctalia "volume-mute";
            allow-when-locked = true;
          };

          "XF86AudioLowerVolume" = {
            action.spawn = noctalia "volume-down";
            allow-when-locked = true;
          };

          "XF86AudioRaiseVolume" = {
            action.spawn = noctalia "volume-up";
            allow-when-locked = true;
          };

          "XF86AudioMicMute" = {
            action.spawn = noctalia "mic-mute";
            allow-when-locked = true;
          };

          # Media Controls

          "XF86AudioPrev" = {
            action.spawn = noctalia "media previous";
            allow-when-locked = true;
          };

          "XF86AudioPlay" = {
            action.spawn = noctalia "media toggle";
            allow-when-locked = true;
          };

          "XF86AudioNext" = {
            action.spawn = noctalia "media next";
            allow-when-locked = true;
          };

          # Screen Brightness

          "XF86MonBrightnessDown" = {
            action.spawn = noctalia "brightness-down";
            allow-when-locked = true;
          };

          "XF86MonBrightnessUp" = {
            action.spawn = noctalia "brightness-up";
            allow-when-locked = true;
          };

          # Session Management

          "Mod+Alt+Escape" = {
            action.spawn = noctalia "session lock";
            hotkey-overlay.title = "Lock Screen";
          };

          # Toggleable Menus

          "Mod+Escape" = {
            action.spawn = noctalia "panel-toggle session";
            hotkey-overlay.title = "Toggle Session Menu";
          };

          "Mod+F1" = {
            action.spawn = noctalia "panel-toggle clipboard";
            hotkey-overlay.title = "Toggle Clipboard Menu";
          };

          "Mod+F2" = {
            action.spawn = noctalia "panel-toggle liamwh/emoji-picker:desktop";
            hotkey-overlay.title = "Toggle Emoji Picker";
          };

          "Mod+Space" = {
            action.spawn = noctalia "panel-toggle launcher";
            hotkey-overlay.title = "Toggle Launcher";
          };

          "Mod+Alt+Space" = {
            action.spawn = noctalia "panel-toggle control-center notifications";
            hotkey-overlay.title = "Toggle Notification Centre";
          };
        };

        debug = {
          honor-xdg-activation-with-invalid-serial = [ ];
        };

        spawn-at-startup = [ { argv = [ (lib.getExe pkgs.noctalia) ]; } ];
      };

      umbriel.settings = {
        keybinds = {
          # Audio Controls

          XF86AudioMute = {
            action = "spawn noctalia msg volume-mute";
            allow_when_locked = true;
            repeat = false;
          };

          XF86AudioLowerVolume = {
            action = "spawn noctalia msg volume-down";
            allow_when_locked = true;
          };

          XF86AudioRaiseVolume = {
            action = "spawn noctalia msg volume-up";
            allow_when_locked = true;
          };

          XF86AudioMicMute = {
            action = "spawn noctalia msg mic-mute";
            allow_when_locked = true;
          };

          # Media Controls

          XF86AudioPrev = {
            action = "spawn noctalia msg media previous";
            allow_when_locked = true;
          };

          XF86AudioPlay = {
            action = "spawn noctalia msg media toggle";
            allow_when_locked = true;
            repeat = false;
          };

          XF86AudioNext = {
            action = "spawn noctalia msg media next";
            allow_when_locked = true;
          };

          # Screen Brightness

          XF86MonBrightnessDown = {
            action = "spawn noctalia msg brightness-down";
            allow_when_locked = true;
          };

          XF86MonBrightnessUp = {
            action = "spawn noctalia msg brightness-up";
            allow_when_locked = true;
          };

          # Session Management

          "Mod+Alt+Escape".action = "spawn noctalia msg session lock";

          # Toggleable Menus

          "Mod+Escape".action = "spawn noctalia msg panel-toggle session";
          "Mod+F1".action = "spawn noctalia msg panel-toggle clipboard";
          "Mod+F2".action = "spawn noctalia msg panel-toggle liamwh/emoji-picker:desktop";
          Mod.action = "spawn noctalia msg panel-toggle launcher";
          "Mod+Alt+Space".action = "spawn noctalia msg panel-toggle control-center notifications";
        };

        layer_rule = [
          {
            match.namespace = "^noctalia-(bar-[^\"]+|notification|dock|panel|attached-panel|osd|desktop-widget-[^\"]*)$";
            blur = true;
            blur_ignore_alpha = 0.5;
            blur_popups = true;
          }

          {
            match.namespace = "^noctalia-(notification|dock|panel|attached-panel|osd)$";
            blur_optimized = false;
          }
        ];

        window_rule = [
          {
            match.app_id = "^dev.noctalia.Noctalia$";
            default_floating = true;

            default_floating_size_px = {
              width = 1020;
              height = 900;
            };
          }

          {
            match.app_id = "^dev.noctalia.UmbrielSharePicker$";
            default_floating = true;

            default_floating_size_px = {
              width = 800;
              height = 600;
            };
          }
        ];

        general.autostart = [ (lib.getExe pkgs.noctalia) ];
      };
    };

    # Plugin Dependencies
    home.packages = with pkgs; [
      gcc # Game Launcher
      udiskie # Udiskie Manager
    ];
  };
}
