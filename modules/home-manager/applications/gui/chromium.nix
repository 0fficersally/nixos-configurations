# Web Browser (Blink Engine)
{ config, lib, pkgs, ... }: {
  options = {
    modules.applications.gui.chromium.enable = lib.mkEnableOption "the Chromium web browser";
  };

  config = lib.mkIf config.modules.applications.gui.chromium.enable {
    programs.chromium = {
      enable = true;
      package = pkgs.ungoogled-chromium; # Libre

      extensions = [
        { id = "cgffilbpcibhmcfbgggfhfolhkfbhmik"; } # Immersive Web Emulator
        { id = "ilcajpmogmhpliinlbcdebhbcanbghmd"; } # Preact Developer Tools
        { id = "fmkadmapgofadopljbjfkapdkoienihi"; } # React Developer Tools
        { id = "cdockenadnadldjbbgcallicgledbeoc"; } # VisBug
        { id = "jnbbnacmeggbgdjgaoojpmhdlkkpblgi"; } # WakaTime
      ];
    };
  };
}
