# PIM Suite
{ config, lib, ... }: {
  options = {
    modules.applications.gui.thunderbird.enable = lib.mkEnableOption "the Thunderbird PIM suite";
  };

  config = lib.mkIf config.modules.applications.gui.thunderbird.enable {
    programs.thunderbird = {
      enable = true;

      profiles.default = {
        isDefault = true; # Temporary
      };
    };
  };
}
