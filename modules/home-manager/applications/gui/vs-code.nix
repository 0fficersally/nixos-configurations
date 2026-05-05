# Integrated Development Environment
{ config, lib, pkgs, osConfig, nix4vscode, ... }: {
  options = {
    modules.applications.gui.vsCode.enable = lib.mkEnableOption "the Visual Studio Code IDE";
  };

  config = lib.mkIf config.modules.applications.gui.vsCode.enable {
    nixpkgs.overlays = [ nix4vscode.overlays.default ];

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
