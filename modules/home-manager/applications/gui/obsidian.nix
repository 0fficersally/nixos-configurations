# Personal Knowledge Base
{ config, lib, ... }: {
  options = {
    modules.applications.gui.obsidian.enable = lib.mkEnableOption "the Obsidian personal knowledge base";
  };

  config = lib.mkIf config.modules.applications.gui.obsidian.enable {
    programs.obsidian = {
      enable = true;
    };
  };
}
