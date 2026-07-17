{ config, lib, ... }: {
  options.modules.environments.desktop.shells.noctalia = {
    enable = lib.mkEnableOption "the Noctalia desktop shell";
  
    version = lib.mkOption {
      description = "Which Noctalia version to use.";
      type = lib.types.enum [ "v4" "v5" ];
      default = "v5"; # Rewrite
    };
  };

  config = lib.mkIf config.modules.environments.desktop.shells.noctalia.enable {
    services.cliphist.enable = true; # Wayland Clipboard Manager
  };

  imports = [
    ./v4.nix # Legacy
    ./v5.nix # Rewrite
  ];
}
