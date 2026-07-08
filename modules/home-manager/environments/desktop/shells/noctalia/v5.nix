# Rewrite
{ config, lib, pkgs, ... }: let noctalia = config.modules.environments.desktop.shells.noctalia; in {
  config = lib.mkIf (noctalia.enable && noctalia.version == "v5") {
    programs.noctalia = {
      enable = true;
    };
  };
}
