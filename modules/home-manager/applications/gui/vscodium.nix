# Integrated Development Environment
{ config, lib, pkgs, osConfig, nix4vscode, ... }: {
  options = {
    modules.applications.gui.vscodium.enable = lib.mkEnableOption "the VSCodium IDE";
  };

  config = lib.mkIf config.modules.applications.gui.vscodium.enable {
    nixpkgs.overlays = [ nix4vscode.overlays.default ];

    programs.vscodium = {
      enable = true;

      # Settings Synchronisation
      profiles.default.extensions = pkgs.nix4vscode.forOpenVsx [
        "zokugun.cron-tasks"
        "zokugun.sync-settings"
      ];
    };

    # Sync Settings Configuration
    xdg.configFile."VSCodium/User/globalStorage/zokugun.sync-settings/settings.yml".text = ''
      hostname: ${osConfig.networking.hostName}
      profile: default

      repository:
        type: dummy
    '';
  };
}
