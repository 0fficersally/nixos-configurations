# Git Client
{ config, lib, ... }: {
  options = {
    modules.applications.tui.lazygit.enable = lib.mkEnableOption "the lazygit Git client";
  };

  config = lib.mkIf config.modules.applications.tui.lazygit.enable {
    programs.lazygit = {
      enable = true;

      settings = {
        gui.theme = with config.modules.appearance.colors.schemes.catppuccin.macchiato; {
          defaultFgColor = [ text ];
          selectedLineBgColor = [ surface0 ];
          unstagedChangesColor = [ red ];
          optionsTextColor = [ blue ];
          cherryPickedCommitBgColor = [ surface1 ];
          cherryPickedCommitFgColor = [ sky ];
          inactiveBorderColor = [ subtext0 ];
          activeBorderColor = [ "bold" sky ];
          searchingActiveBorderColor = [ yellow ];
          authorColors."*" = lavender;
        };
      };
    };
  };
}
