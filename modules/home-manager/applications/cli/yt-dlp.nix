# Audio and Video Downloader
{ config, lib, ... }: {
  options = {
    modules.applications.cli.yt-dlp.enable = lib.mkEnableOption "the yt-dlp audio and video downloader";
  };

  config = lib.mkIf config.modules.applications.cli.yt-dlp.enable {
    programs.yt-dlp = {
      enable = true;
    };
  };
}
