# Text Editor
{ config, lib, nixvim, ... }: {
  options = {
    modules.applications.tui.neovim.enable = lib.mkEnableOption "the Neovim text editor";
  };

  config = lib.mkIf config.modules.applications.tui.neovim.enable {
    programs.nixvim = {
      enable = true;
      defaultEditor = true;

      colorschemes.catppuccin = {
        enable = true;

        settings = {
          flavour = "macchiato";
          transparent_background = true;
        };
      };
    };
  };
}
