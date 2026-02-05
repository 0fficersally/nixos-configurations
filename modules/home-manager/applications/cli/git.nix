# Version Control System
{ config, lib, ... }: {
  options = {
    modules.applications.cli.git.enable = lib.mkEnableOption "the Git version control system";
  };

  config = lib.mkIf config.modules.applications.cli.git.enable {
    programs.git = {
      enable = true;

      settings = {
        user = {
          name = "Lysander Fontyn";
          email = "lysander.fontyn@zerofisher.dev";
        };

        init.defaultBranch = "main";
      };
    };
  };
}
