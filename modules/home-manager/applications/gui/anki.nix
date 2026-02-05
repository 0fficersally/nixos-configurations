# Flashcard Program
{ config, lib, pkgs, ... }: {
  options = {
    modules.applications.gui.anki.enable = lib.mkEnableOption "the Anki flashcard program";
  };

  config = lib.mkIf config.modules.applications.gui.anki.enable {
    programs.anki = {
      enable = true;
      language = "en_GB";

      addons = let catppuccinColorSchemes = pkgs.fetchFromGitHub {
        owner = "catppuccin";
        repo = "anki";
        rev = "f928771a0342626b7330a9d06b8df289f134813f";
        hash = "sha256-pMqv7xCfUvsTgInW/am1tBC7W1Ntt6sUD8hbUybNTZQ=";
      }; in with pkgs.ankiAddons; [
        (recolor.withConfig { config = builtins.fromJSON (builtins.readFile "${catppuccinColorSchemes}/themes/macchiato.json"); })
        review-heatmap
      ];
    };
  };
}
