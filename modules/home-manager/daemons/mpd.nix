# Music Player Daemon
{ config, lib, ... }: {
  options = {
    modules.daemons.mpd.enable = lib.mkEnableOption "Music Player Daemon (MPD)";
  };

  config = lib.mkIf config.modules.daemons.mpd.enable {
    services = {
      mpd = {
        enable = true;
        musicDirectory = "${config.home.homeDirectory}/Nextcloud/Media/Audio/Music/Sources";
        playlistDirectory = "${config.home.homeDirectory}/Nextcloud/Media/Audio/Music/Playlists";
        network.startWhenNeeded = true;

        extraConfig = lib.mkBefore ''
          audio_output {
            type "pipewire"
            name "PipeWire Sound Server"
          }
        '';
      };

      listenbrainz-mpd = {
        enable = true;

        # TOML
        settings = {
          mpd.address = "/run/user/1000/mpd/socket";
          submission.token_file = config.sops.secrets."api-keys/listenbrainz".path;
        };
      };

      mpd-discord-rpc = {
        enable = true;

        # TOML
        settings = {
          hosts = [ "/run/user/1000/mpd/socket" ];
          id = "1458843884212846768";

          format = {
            display_type = "name";
            small_image = "notes";
            small_text = "";
            large_image = "notes";
            large_text = "";
            details = "$title";
            state = "$artist / $album";
            timestamp = "both";
          };
        };
      };
    };
  };
}
