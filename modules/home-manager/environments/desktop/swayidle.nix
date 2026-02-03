# Idle Management Daemon
{ config, lib, pkgs, self, ... }: {
  options = {
    modules.environments.desktop.swayidle.enable = lib.mkEnableOption "the swayidle idle management daemon";
  };

  config = lib.mkIf config.modules.environments.desktop.swayidle.enable {
    home.packages = [ pkgs.libnotify ]; # Desktop Notification Library

    nixpkgs.overlays = [ (final: prev: {
      scripts = (prev.scripts or {}) // {
        # Control Display Power State
        screen-state = final.writeShellApplication {
          name = "screen-state";
          runtimeInputs = with final; [ niri sway ];
          text = builtins.readFile (builtins.toPath "${self}/scripts/screen-state.sh");
        };
      };
    }) ];

    services.swayidle = let
      screenState = state: "${lib.getExe pkgs.scripts.screen-state} ${state}";
      lockScreen = "${lib.getExe pkgs.swaylock} --daemonize";
    in {
      enable = true;

      events = {
        lock = "${screenState "off"}; ${lockScreen}";
        unlock = screenState "on";
        before-sleep = "${screenState "off"}; ${lockScreen}";
        after-resume = screenState "on";
      };

      timeouts = [
        {
          timeout = 145; # 5 Seconds Earlier
          command = "${lib.getExe' pkgs.libnotify "notify-send"} 'Turning Off Screen' 'The screen will turn off in five seconds.' --expire-time 5000";
        }

        {
          timeout = 150; # 2.5 Minutes
          command = screenState "off";
          resumeCommand = screenState "on";
        }

        {
          timeout = 300; # 5 Minutes
          command = lockScreen;
        }

        {
          timeout = 600; # 10 Minutes
          command = "${lib.getExe' pkgs.systemd "systemctl"} suspend";
        }
      ];
    };
  };
}
