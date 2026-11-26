# Web Application Dashboard
{ config, lib, ... }: {
  options = {
    modules.applications.web.homepage.enable = lib.mkEnableOption "the Homepage web application dashboard";
  };

  config = lib.mkIf config.modules.applications.web.homepage.enable {
    sops.secrets."environment-variables/homepage" = { };

    services.homepage-dashboard = {
      enable = true;
      environmentFiles = [ config.sops.secrets."environment-variables/homepage".path ];

      widgets = [
        {
          search = {
            provider = "custom";
            showSearchSuggestions = true;
            suggestionUrl = "https://searxng.zerofisher.dev/autocompleter?q=";
            url = "https://searxng.zerofisher.dev/search?q=";
            target = "_blank";
          };
        }
      ];

      services = [
        {
          Peridot = [
            {
              Services = [
                {
                  "qBittorrent".widget = {
                    type = "qbittorrent";
                    url = "http://localhost:7333";
                    enableLeechProgress = true;
                    enableLeechSize = true;
                  };
                }
              ];
            }
          ];
        }

        {
          Ruby = [
            {
              Services = [
                {
                  "Nextcloud".widget = {
                    type = "nextcloud";
                    url = "https://nextcloud.zerofisher.dev";
                    key = "{{HOMEPAGE_VAR_NEXTCLOUD}}";
                  };
                }

                {
                  "Immich".widget = {
                    type = "immich";
                    version = 2;
                    url = "https://immich.zerofisher.dev";
                    key = "{{HOMEPAGE_VAR_IMMICH}}";
                  };
                }
              ];
            }

            {
              Minecraft = [
                {
                  "Bannerfall".widget = {
                    type = "minecraft";
                    url = "udp://bannerfall.zerofisher.dev";
                  };
                }

                {
                  "Cobblemon".widget = {
                    type = "minecraft";
                    url = "udp://cobblemon.zerofisher.dev";
                  };
                }

                {
                  "Musubi Retreat".widget = {
                    type = "minecraft";
                    url = "udp://musubi-retreat.zerofisher.dev";
                  };
                }

                {
                  "ᴏᴋᴛᴏʙᴇʀᴄʀᴀꜰᴛ".widget = {
                    type = "minecraft";
                    url = "udp://oktobercraft.zerofisher.dev";
                  };
                }
              ];
            }
          ];
        }
      ];

      listenPort = 4663;
      allowedHosts = "127.0.0.1:4663,localhost:4663";
    };
  };
}
