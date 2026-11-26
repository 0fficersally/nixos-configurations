# Code Editor
{ config, lib, pkgs, ... }: {
  options = {
    modules.applications.gui.zed.enable = lib.mkEnableOption "the Zed code editor";
  };

  config = lib.mkIf config.modules.applications.gui.zed.enable {
    programs.zed-editor = {
      enable = true;

      extraPackages = with pkgs; [
        nixd # Nix Language Server
      ];

      extensions = [
        "caddyfile"
        "catppuccin"
        "catppuccin-icons"
        "deno"
        "docker-compose"
        "dockerfile"
        "gdscript"
        "mermaid"
        "nix"
        "toml"
        "wakatime"
        "xml"
      ];

      # Catppuccin Sky Accent
      themes.catppuccin-sky = builtins.fetchurl {
        url = "https://github.com/catppuccin/zed/releases/download/v0.2.26/catppuccin-sky.json";
        sha256 = "4dbdb67b9aa668da59073968a711742d218e3cb475d9d2dc90280070eb2ab41d";
      };
    };
  };
}
