# Bitwarden (Password Manager)
{ config, lib, pkgs, ... }: {
  options = {
    modules.applications.cli.rbw.enable = lib.mkEnableOption "the rbw Bitwarden CLI";
  };

  config = lib.mkIf config.modules.applications.cli.rbw.enable {
    programs.rbw.enable = true;

    sops.templates."config.json" = {
      path = "${config.xdg.configHome}/rbw/config.json";

      content = builtins.toJSON {
        base_url = "https://api.bitwarden.eu";
        ui_url = "https://vault.bitwarden.eu";
        email = config.sops.placeholder."email-addresses/personal";
        pinentry = lib.getExe pkgs.pinentry-rofi;
        lock_timeout = 1800; # 30 Minutes
      };
    };
  };
}
