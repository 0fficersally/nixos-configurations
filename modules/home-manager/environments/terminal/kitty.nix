# Terminal Emulator
{ config, lib, ... }: {
  options = {
    modules.environments.terminal.kitty.enable = lib.mkEnableOption "the kitty terminal emulator";
  };

  config = lib.mkIf config.modules.environments.terminal.kitty.enable {
    programs.kitty = {
      enable = true;
      enableGitIntegration = true;

      settings = {
        confirm_os_window_close = 0;
        window_margin_width = 6; # Points
        background_opacity = 0.9;
      };

      font.name = "Maple Mono NF CN";
      themeFile = "Catppuccin-Macchiato";
    };
  };
}
