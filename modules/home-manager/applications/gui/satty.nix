# Screenshot Annotation Tool
{ config, lib, pkgs, ... }: {
  options = {
    modules.applications.gui.satty.enable = lib.mkEnableOption "the Satty screenshot annotation tool";
  };

  config = lib.mkIf config.modules.applications.gui.satty.enable {
    home.packages = with pkgs; [
      satty
      wl-clipboard # Wayland Clipboard Utilities
    ];

    xdg.configFile."satty/config.toml".text = ''
      [general]
      fullscreen = true
      initial-tool = "brush"
      copy-command = "wl-copy"
      output-filename = "${config.xdg.userDirs.pictures}/Screenshots/Screenshot_%Y-%m-%d_%H-%M-%S.png"
      early-exit = true

      [font]
      family = "Noto Sans"
    '';
  };
}
