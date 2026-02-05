# Audio Visualiser
{ config, lib, ... }: {
  options = {
    modules.applications.tui.cava.enable = lib.mkEnableOption "the CAVA audio visualiser";
  };

  config = lib.mkIf config.modules.applications.tui.cava.enable {
    programs.cava = {
      enable = true;

      settings = {
        color = with config.modules.appearance.colors.schemes.catppuccin.macchiato; {
          gradient = 1;
          gradient_color_1 = "'${teal}'";
          gradient_color_2 = "'${sky}'";
          gradient_color_3 = "'${sapphire}'";
          gradient_color_4 = "'${blue}'";
          gradient_color_5 = "'${mauve}'";
          gradient_color_6 = "'${pink}'";
          gradient_color_7 = "'${maroon}'";
          gradient_color_8 = "'${red}'";
        };
      };
    };

    services.mpd.extraConfig = lib.mkAfter ''
      audio_output {
        type "fifo"
        name "Cava Audio Visualiser"
        path "/tmp/mpd.fifo"
        format "44100:16:2"
      }
    '';
  };
}
