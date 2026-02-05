# File Manager
{ config, lib, pkgs, ... }: {
  options = {
    modules.applications.tui.yazi.enable = lib.mkEnableOption "the Yazi file manager";
  };

  config = lib.mkIf config.modules.applications.tui.yazi.enable {
    programs.yazi = {
      enable = true;
      shellWrapperName = "f";

      settings = {
        mgr = {
          show_hidden = true;
          sort_by = "extension";
        };

        input.cursor_blink = true;
      };

      # Integrations
      extraPackages = with pkgs; [
        _7zz
        fd
        ffmpeg
        file
        fzf
        imagemagick
        jq
        poppler
        resvg
        ripgrep
        zoxide
      ];

      flavors = let yaziFlavors = pkgs.fetchFromGitHub {
        owner = "yazi-rs";
        repo = "flavors";
        rev = "3edeb49597e1080621a9b0b50d9f0a938b8f62bb";
        hash = "sha256-twgXHeIj52EfpMpLrhxjYmwaPnIYah3Zk/gqCNTb2SQ=";
      }; in {
        # Catppuccin
        catppuccin-latte = "${yaziFlavors}/catppuccin-latte.yazi"; # Light
        catppuccin-frappe = "${yaziFlavors}/catppuccin-frappe.yazi"; # Dark
        catppuccin-macchiato = "${yaziFlavors}/catppuccin-macchiato.yazi"; # Darker
        catppuccin-mocha = "${yaziFlavors}/catppuccin-mocha.yazi"; # Darkest
      };

      theme.flavor = {
        light = "catppuccin-latte";
        dark = "catppuccin-macchiato";
      };
    };
  };
}
