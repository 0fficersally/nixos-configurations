# On-Screen Display
{ config, lib, ... }: {
  options = {
    modules.environments.desktop.swayosd.enable = lib.mkEnableOption "the SwayOSD on-screen display";
  };

  config = lib.mkIf config.modules.environments.desktop.swayosd.enable {
    services.swayosd.enable = true;

    xdg.configFile."swayosd/style.css".text = with config.modules.appearance.colors.schemes.catppuccin.macchiato; ''
      window#osd {
        border-radius: 999px;
        border: none;
        background: #{"alpha(${base}, 0.8)"};

        #container {
          margin: 16px;
        }

        image,
        label {
          color: #{"${text}"};
        }

        progressbar:disabled,
        image:disabled {
          opacity: 0.5;
        }

        progressbar,
        segmentedprogress {
          min-height: 6px;
          border-radius: 999px;
          background: transparent;
          border: none;
        }
        trough,
        segment {
          min-height: inherit;
          border-radius: inherit;
          border: none;
          background: #{"alpha(${text}, 0.5)"};
        }
        progress,
        segment.active {
          min-height: inherit;
          border-radius: inherit;
          border: none;
          background: #{"${text}"};
        }

        segment {
          margin-left: 8px;
          &:first-child {
            margin-left: 0;
          }
        }
      }
    '';
  };
}
