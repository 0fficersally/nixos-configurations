# Application Launcher
{ config, lib, pkgs, rofi-tools, ... }: {
  options = {
    modules.environments.desktop.rofi.enable = lib.mkEnableOption "the Rofi application launcher";
  };

  config = lib.mkIf config.modules.environments.desktop.rofi.enable {
    programs.rofi = {
      enable = true;
      terminal = lib.getExe pkgs.kitty;

      modes = [
        "combi"
        "drun"
        "run"
        "ssh"
        "window"
      ];

      extraConfig = {
        combi-modes = "window,drun,run,ssh";
        run-shell-command = "{terminal} --hold {cmd}"; # Keep Window Open
        show-icons = true;
      };

      location = "top";
      font = "Maple Mono NF CN 12"; # Points

      theme = let inherit (config.lib.formats.rasi) mkLiteral; in with config.modules.appearance.colors.schemes.catppuccin.macchiato; {
        "*" = {
          selected-active-foreground = mkLiteral "@background";
          lightfg = mkLiteral text;
          separatorcolor = mkLiteral "@foreground";
          urgent-foreground = mkLiteral red;
          alternate-urgent-background = mkLiteral "@lightbg";
          lightbg = mkLiteral mantle;
          background-color = mkLiteral "transparent";
          border-color = mkLiteral sky;
          normal-background = mkLiteral "@background";
          selected-urgent-background = mkLiteral red;
          alternate-active-background = mkLiteral "@lightbg";
          spacing = 2;
          alternate-normal-foreground = mkLiteral "@foreground";
          urgent-background = mkLiteral "@background";
          selected-normal-foreground = mkLiteral "@lightbg";
          active-foreground = mkLiteral blue;
          background = mkLiteral base;
          selected-active-background = mkLiteral blue;
          active-background = mkLiteral "@background";
          selected-normal-background = mkLiteral "@lightfg";
          alternate-normal-background = mkLiteral "@lightbg";
          foreground = mkLiteral text;
          selected-urgent-foreground = mkLiteral "@background";
          normal-foreground = mkLiteral "@foreground";
          alternate-urgent-foreground = mkLiteral red;
          alternate-active-foreground = mkLiteral blue;
        };

        element = {
          padding = mkLiteral "1px";
          cursor = mkLiteral "pointer";
          spacing = mkLiteral "5px";
          border = 0;
        };

        "element normal.normal" = {
          background-color = mkLiteral "@normal-background";
          text-color = mkLiteral "@normal-foreground";
        };

        "element normal.urgent" = {
          background-color = mkLiteral "@urgent-background";
          text-color = mkLiteral "@urgent-foreground";
        };

        "element normal.active" = {
          background-color = mkLiteral "@active-background";
          text-color = mkLiteral "@active-foreground";
        };

        "element selected.normal" = {
          background-color = mkLiteral "@selected-normal-background";
          text-color = mkLiteral "@selected-normal-foreground";
        };

        "element selected.urgent" = {
          background-color = mkLiteral "@selected-urgent-background";
          text-color = mkLiteral "@selected-urgent-foreground";
        };

        "element selected.active" = {
          background-color = mkLiteral "@selected-active-background";
          text-color = mkLiteral "@selected-active-foreground";
        };

        "element alternate.normal" = {
          background-color = mkLiteral "@alternate-normal-background";
          text-color = mkLiteral "@alternate-normal-foreground";
        };

        "element alternate.urgent" = {
          background-color =mkLiteral "@alternate-urgent-background";
          text-color = mkLiteral "@alternate-urgent-foreground";
        };

        "element alternate.active" = {
          background-color = mkLiteral "@alternate-active-background";
          text-color = mkLiteral "@alternate-active-foreground";
        };

        element-text = {
          background-color = mkLiteral "transparent";
          cursor = mkLiteral "inherit";
          highlight = mkLiteral "inherit";
          text-color = mkLiteral "inherit";
        };

        element-icon = {
          background-color = mkLiteral "transparent";
          size = mkLiteral "1.0000em";
          cursor = mkLiteral "inherit";
          text-color = mkLiteral "inherit";
        };

        window = {
          padding = 5;
          margin = 8;
          background-color = mkLiteral "@background";
          border = 2;
          border-radius = 12; # Rounded Corners
        };

        mainbox = {
          padding = 0;
          border = 0;
        };

        message = {
          padding = mkLiteral "1px";
          border-color = mkLiteral "@separatorcolor";
          border = mkLiteral "2px dash 0px 0px";
        };

        textbox = {
          text-color = mkLiteral "@foreground";
        };

        listview = {
          padding = mkLiteral "2px 0px 0px";
          scrollbar = true;
          border-color = mkLiteral "@separatorcolor";
          spacing = mkLiteral "2px";
          fixed-height = 0;
          border = mkLiteral "2px dash 0px 0px";
        };

        scrollbar = {
          width = mkLiteral "4px";
          padding = 0;
          handle-width = mkLiteral "8px";
          border = 0;
          handle-color = mkLiteral "@normal-foreground";
        };

        sidebar = {
          border-color = mkLiteral "@separatorcolor";
          border = mkLiteral "2px dash 0px 0px";
        };

        button = {
          cursor = mkLiteral "pointer";
          spacing = 0;
          text-color = mkLiteral "@normal-foreground";
        };

        "button selected" = {
          background-color = mkLiteral "@selected-normal-background";
          text-color = mkLiteral "@selected-normal-foreground";
        };

        num-filtered-rows = {
          expand = false;
          text-color = mkLiteral "Gray";
        };

        num-rows = {
          expand = false;
          text-color = mkLiteral "Gray";
        };

        textbox-num-sep = {
          expand = false;
          str = "/";
          text-color = mkLiteral "Gray";
        };

        inputbar = {
          padding = mkLiteral "1px";
          spacing = mkLiteral "0px";
          text-color = mkLiteral "@normal-foreground";
          children = [ "prompt" "textbox-prompt-colon" "entry" "num-filtered-rows" "textbox-num-sep" "num-rows" "case-indicator" ];
        };

        case-indicator = {
          spacing = 0;
          text-color = mkLiteral "@normal-foreground";
        };

        entry = {
          text-color = mkLiteral "@normal-foreground";
          cursor = mkLiteral "text";
          spacing = 0;
          placeholder-color = mkLiteral "Gray";
          placeholder = "Type to filter";
        };

        prompt = {
          spacing = 0;
          text-color = mkLiteral "@normal-foreground";
        };

        textbox-prompt-colon = {
          margin = mkLiteral "0px 0.3000em 0.0000em 0.0000em";
          expand = false;
          str = " =";
          text-color = mkLiteral "inherit";
        };
      };
    };

    # Scripts
    home.packages = with pkgs; [
      (rofi-rbw.override { waylandSupport = true; }) # Password Manager
      rofi-tools.packages.${pkgs.stdenv.hostPlatform.system}.rofi-cliphist # Clipboard Manager
      (rofimoji.override { waylandSupport = true; }) # Character Picker
    ];

    # Script Settings
    xdg.configFile = {
      # Password Manager
      "rofi-rbw.rc".text = ''
        target = password
        clear-after = 15
      '';

      # Clipboard Manager
      "rofi-cliphist.toml".text = ''
        [rofi]
        path = "${lib.getExe pkgs.rofi}"
        
        [cliphist]
        path = "${lib.getExe pkgs.cliphist}"

        [clipboard]
        path = "${lib.getExe' pkgs.wl-clipboard "wl-copy"}"
      '';

      # Character Picker
      "rofimoji.rc".text = ''
        files = all
        skin-tone = neutral
      '';
    };
  };
}
