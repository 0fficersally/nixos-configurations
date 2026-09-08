# Code Editor
{ config, lib, ... }: {
  options = {
    modules.applications.gui.zed.enable = lib.mkEnableOption "the Zed code editor";
  };

  config = lib.mkIf config.modules.applications.gui.zed.enable {
    programs.zed-editor = {
      enable = true;

      extensions = [
        "catppuccin-icons"
        "catppuccin"
        "deno"
        "docker-compose"
        "dockerfile"
        "mermaid"
        "nix"
        "toml"
        "wakatime"
      ];
    };
  };
}
