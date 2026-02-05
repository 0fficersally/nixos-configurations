# CD-DA Ripper
{ config, lib, pkgs, ... }: {
  options = {
    modules.applications.cli.whipper.enable = lib.mkEnableOption "the Whipper CD-DA ripper";
  };

  config = lib.mkIf config.modules.applications.cli.whipper.enable {
    home.packages = [ pkgs.whipper ];

    xdg.configFile."whipper/whipper.conf".text = ''
      [main]
      path_filter_vfat = True
      path_filter_printable = True
      path_filter_whitespace = True

      [whipper.cd.rip]
      prompt = True
      working_directory = ~/.cache/whipper
      output_directory = ~/Music/Whipper
      disc_template = %%A/%%R/%%d/Disc-%%N/%%A_%%y_%%D_%%c_%%T
      track_template = %%A/%%R/%%d/Disc-%%N/%%T_%%t_%%a_%%n
      cover_art = complete

      [drive:HL-DT-ST%3ABDDVDRW%20CT30F%20%20%20%3AYT04]
      vendor = HL-DT-ST
      model = BDDVDRW CT30F
      release = YT04
      defeats_cache = True
      read_offset = 102
    '';
  };
}
