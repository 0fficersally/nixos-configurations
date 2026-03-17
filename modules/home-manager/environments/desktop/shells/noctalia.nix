{ config, lib, ... }: {
  options = {
    modules.environments.desktop.shells.noctalia.enable = lib.mkEnableOption "the Noctalia desktop shell";
  };

  config = lib.mkIf config.modules.environments.desktop.shells.noctalia.enable {
    programs.noctalia-shell = {
      enable = true;
    };
  };
}
