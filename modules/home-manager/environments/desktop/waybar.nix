# Status Bar
{ config, lib, pkgs, ... }: {
  options = {
    modules.environments.desktop.waybar.enable = lib.mkEnableOption "the Waybar status bar";
  };

  config = lib.mkIf config.modules.environments.desktop.waybar.enable {
    programs.waybar = {
      enable = true;

      settings = let
        kitty = lib.getExe pkgs.kitty;
        swayosd-client = lib.getExe' pkgs.swayosd "swayosd-client";
      in [
        {
          layer = "top";
          height = 32;
          margin-top = 8;
          margin-right = 8;
          margin-left = 8;
          modules-left = [ "tray" "group/context" "niri/workspaces" "wlr/taskbar" ];
          modules-center = [ "niri/window" ];
          modules-right = [ "group/connectivity" "group/audio" "group/display" "group/power" "clock" ];
          spacing = 8;

          tray = {
            icon-size = 24;
            spacing = 4;
          };

          "group/context" = {
            modules = [ "privacy" "gamemode" ];
            orientation = "horizontal";
          };

          privacy = {
            icon-size = 24;
            icon-spacing = 4;
          };

          gamemode = {
            format = "{glyph}";
            tooltip-format = "{count} Running Games";
            icon-size = 24;
            icon-spacing = 4;
          };

          "niri/workspaces" = {
            format = "{value}";
          };

          "wlr/taskbar" = {
            format = "{icon}";

            tooltip-format = builtins.concatStringsSep "\n" [
              "󰣆 {name}"
              "󰓹 {app_id}"
            ];

            icon-size = 24;
            sort-by-app-id = true;
            on-click = "activate";
            on-click-right = "maximize";
            on-click-middle = "close";
          };

          "niri/window" = {
            format = "{title}";
            separate-outputs = true;
          };

          "group/connectivity" = {
            modules = [ "network" "bluetooth" ];
            orientation = "horizontal";
          };

          network = {
            format = "{icon}";

            tooltip-format-ethernet = builtins.concatStringsSep "\n" [
              "󰩠 {ipaddr}/{cidr}"
              "󰇚 {bandwidthDownBits} 󰕒 {bandwidthUpBits}"
            ];

            tooltip-format-wifi = builtins.concatStringsSep "\n" [
              "󰓹 {essid}\t󰘊 {signaldBm} dBm"
              "󰀃 {frequency} GHz\t󰇚 {bandwidthDownBits} 󰕒 {bandwidthUpBits}"
            ];

            format-icons = {
              disabled = "󰌺";
              disconnected = "󰖪";
              linked = "󰌹";
              ethernet = "󰈀";
              wifi = "󰖩";
            };

            on-click = "${kitty} ${lib.getExe pkgs.wifitui}"; # Wi-Fi Manager
          };

          bluetooth = {
            format-no-controller = "󰂲";
            format-disabled = "󰂲";
            format-off = "󰂲";
            format-on = "󰂯";
            format-connected = "󰂱";
            tooltip-format-disabled = "Disabled";
            tooltip-format-off = "Off";
            tooltip-format-on = "On";

            tooltip-format-connected = builtins.concatStringsSep "\n" [
              "󰓹 {controller_alias} 󰘚 {controller_address} 󰾰 {num_connections}"
              "\n{device_enumerate}"
            ];

            tooltip-format-enumerate-connected = "󰓹 {device_alias} 󰘚 {device_address}";
            tooltip-format-enumerate-connected-battery = "󰓹 {device_alias} 󰘚 {device_address} 󰥉 {device_battery_percentage} %";
            on-click = "${kitty} ${lib.getExe pkgs.bluetui}"; # Bluetooth Manager
          };

          "group/audio" = {
            modules = [ "wireplumber" "jack" ];
            orientation = "horizontal";
            drawer.transition-duration = 500;
          };

          wireplumber = {
            format = "{icon} {volume} % {format_source}";
            format-muted = "󰝟 {format_source}";
            format-source = "󰍬 {volume} %";
            format-source-muted = "󰍭";

            tooltip-format = builtins.concatStringsSep "\n" [
              "󰓹 {node_name}"
              "󱄠 {source_desc}"
            ];

            format-icons = [ "󰕿" "󰖀" "󰕾" ];
            on-click = "${kitty} ${lib.getExe pkgs.wiremix}"; # PipeWire Audio Mixer
            on-click-right = "${kitty} ${lib.getExe pkgs.rmpc}"; # MPD Client
            on-click-middle = "${swayosd-client} --output-volume mute-toggle";
            on-scroll-down = "${swayosd-client} --output-volume -5";
            on-scroll-up = "${swayosd-client} --output-volume +5";
          };

          jack = {
            format-disconnected = "󱑽 DSP Off";
            format-connected = "󱑽 {load} %";
            format-xrun = "󱑽 {xruns} XRuns";

            tooltip-format = builtins.concatStringsSep "\n" [
              "󱎫 {latency} ms"
              "󰍛 {bufsize} Frames"
              "󰓅 {samplerate} Hz"
            ];

            on-click = lib.getExe pkgs.qpwgraph; # Audio Patchbay
            on-click-right = "${kitty} ${lib.getExe pkgs.cava}"; # Audio Visualiser
          };
      
          "group/display" = {
            modules = [ "backlight" "idle_inhibitor" ];
            orientation = "horizontal";
          };

          backlight = {
            format = "{icon} {percent} %";
            tooltip-format = "Screen Brightness";
            format-icons = [ "󰃚" "󰃛" "󰃜" "󰃝" "󰃞" "󰃟" "󰃠" ];
            on-scroll-down = "${swayosd-client} --brightness -10";
            on-scroll-up = "${swayosd-client} --brightness +10";
          };

          idle_inhibitor = {
            format = "{icon}";
            tooltip-format-deactivated = "Fall Asleep";
            tooltip-format-activated = "Stay Awake";

            format-icons = {
              deactivated = "󰒲";
              activated = "󰒳";
            };
          };

          "group/power" = {
            modules = [ "battery" "power-profiles-daemon" ];
            orientation = "horizontal";
          };

          battery = {
            format = "{icon} {capacity} %";

            tooltip-format = builtins.concatStringsSep "\n" [
              "󰔟 {timeTo}"
              "󰉁 {power} W"
              "󰗶 {health} %"
            ];

            format-time = "{H} h {M} min";
            format-icons = [ "󰂎" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" ];
          };

          power-profiles-daemon = {
            format = "{icon}";
            tooltip-format = "{profile}";

            format-icons = {
              default = "󰉁";
              power-saver = "󰌪";
              balanced = "󰗑";
              performance = "󰉁";
            };
          };

          clock = {
            format = builtins.concatStringsSep "\n" [
              "󰥔 {:%H:%M:%S"
              "󰃭 %Y-%m-%d}"
            ];

            tooltip-format = "<tt><small>{calendar}</small></tt>";
            timezone = "Europe/Brussels";
            interval = 1; # Refresh Every Second
          };

          reload_style_on_change = true;
        }
      ];

      style = with config.modules.appearance.colors.schemes.catppuccin.macchiato; ''
        * {
          font-family: "FiraCode Nerd Font Propo";
          font-size: 16px;
        }

        window#waybar {
          background-color: transparent;
        }

        window#waybar.empty #window {
          opacity: 0;
        }

        button:hover {
          background: inherit;
          text-shadow: none;
        }

        #tray,
        #context,
        #workspaces,
        #taskbar,
        #window,
        #connectivity,
        #audio,
        #display,
        #power,
        #clock {
          padding: 8px;
          background-color: ${base};
          color: ${text};
          border: 2px solid ${overlay0};
          border-radius: 12px;
        }

        #gamemode:not(:first-child),
        #bluetooth,
        #jack,
        #idle_inhibitor,
        #power-profiles-daemon {
          margin-left: 0.75em;
        }

        #workspaces button {
          min-width: 8px;
          background-color: ${overlay0};
          color: ${text};
          border: none;
          box-shadow: inset 0 -2px shade(${overlay0}, 0.75);
        }

        #workspaces button:not(:last-child) {
          margin-right: 8px;
        }

        #workspaces button:hover {
          background-color: shade(${overlay0}, 0.75);
        }

        #workspaces button.active {
          min-width: 32px;
          background-color: ${sky};
          color: ${base};
          box-shadow: inset 0 -2px shade(${sky}, 0.75);
        }

        #workspaces button.active:hover {
          background-color: shade(${sky}, 0.75);
        }

        #taskbar button:hover {
          -gtk-icon-shadow: none;
          border: 1px solid ${crust};
          box-shadow: inset 0 -2px ${crust};
          transition: none;
        }

        #window {
          margin: 0 8px;
        }
      '';
    };
  };
}
