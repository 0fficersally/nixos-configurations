# Integrated Development Environment
{ config, lib, pkgs, osConfig, ... }: {
  options = {
    modules.applications.gui.vsCode.enable = lib.mkEnableOption "the Visual Studio Code IDE";
  };

  config = lib.mkIf config.modules.applications.gui.vsCode.enable {
    programs.vscode = {
      enable = true;
      package = pkgs.vscodium; # Libre

      # Settings Synchronisation
      profiles.default.extensions = pkgs.nix4vscode.forOpenVsx [
        "zokugun.cron-tasks"
        "zokugun.sync-settings"
      ];
    };

    xdg.configFile."VSCodium/User/globalStorage/zokugun.sync-settings/settings.yml".text = ''
      hostname: ${osConfig.networking.hostName}
      profile: default

      repository:
        type: dummy
    '';
  };
}
