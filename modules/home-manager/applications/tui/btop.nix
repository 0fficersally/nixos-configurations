# Resource Monitor
{ config, lib, pkgs, ... }: {
  options = {
    modules.applications.tui.btop.enable = lib.mkEnableOption "the btop++ resource monitor";
  };

  config = lib.mkIf config.modules.applications.tui.btop.enable {
    programs.btop = {
      enable = true;

      themes = let catppuccinColorSchemes = pkgs.fetchFromGitHub {
        owner = "catppuccin";
        repo = "btop";
        rev = "f437574b600f1c6d932627050b15ff5153b58fa3";
        hash = "sha256-mEGZwScVPWGu+Vbtddc/sJ+mNdD2kKienGZVUcTSl+c=";
      }; in {
        # Catppuccin
        catppuccin_latte = builtins.toPath "${catppuccinColorSchemes}/themes/catppuccin_latte.theme"; # Light
        catppuccin_frappe = builtins.toPath "${catppuccinColorSchemes}/themes/catppuccin_frappe.theme"; # Dark
        catppuccin_macchiato = builtins.toPath "${catppuccinColorSchemes}/themes/catppuccin_macchiato.theme"; # Darker
        catppuccin_mocha = builtins.toPath "${catppuccinColorSchemes}/themes/catppuccin_mocha.theme"; # Darkest
      };

      settings = {
        vim_keys = true;
        color_theme = "catppuccin_macchiato";
        theme_background = false;
      };
    };
  };
}
