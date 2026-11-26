# Simple Desktop Display Manager
{ config, lib, pkgs, ... }: {
  options = {
    modules.environments.desktop.displayManagers.sddm.enable = lib.mkEnableOption "the Simple Desktop Display Manager (SDDM)";
  };

  config = lib.mkIf config.modules.environments.desktop.displayManagers.sddm.enable {
    services.displayManager = {
      enable = true;

      sddm = {
        enable = true;

        wayland = {
          enable = true;
          compositor = "kwin";
        };

        autoNumlock = true;

        # Noctalia Desktop Shell
        theme = builtins.toString (pkgs.fetchFromGitHub {
          owner = "mahaveergurjar";
          repo = "sddm";
          rev = "40012eecd7f8be7ff4c3ae02241e5f58d28f82f6";
          hash = "sha256-e/gYI6znHXxlDCOVh4p265x3kO0nQUU897hCY1yEz88=";
        });
      };
    };
  };
}
