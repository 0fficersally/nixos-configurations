# Typography
{ config, lib, pkgs, ... }: {
  options = {
    modules.appearance.fonts.enable = lib.mkEnableOption "additional fonts";
  };

  config = lib.mkIf config.modules.appearance.fonts.enable {
    fonts.fontconfig.enable = true;

    home.packages = with pkgs; [
      font-awesome # Icon Glyphs
      maple-mono.NF-CN-unhinted # Monospaced, Ligatures, Icons, Chinese/Japanese Glyphs (>= FHD)
      nerd-fonts.fira-code # Monospaced, Ligatures, Icons
      noto-fonts # Broad Unicode Coverage
      noto-fonts-color-emoji # Emoji Glyphs
    ];

    # Custom Fonts
    xdg.dataFile."fonts" = {
      source = ../../../assets/fonts;
      recursive = true;
    };
  };
}
