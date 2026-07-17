# Web Application Dashboard
{ config, lib, pkgs, ... }: {
  options = {
    modules.applications.web.homepage.enable = lib.mkEnableOption "the Homepage web application dashboard";
  };

  config = lib.mkIf config.modules.applications.web.homepage.enable {
    services.homepage-dashboard = {
      enable = true;
      listenPort = 4663;
      allowedHosts = "127.0.0.1:4663,localhost:4663";

      widgets = [
        {
          search = {
            provider = "custom";
            url = "https://searxng.zerofisher.dev/search?q=";
            showSearchSuggestions = true;
            target = "_blank";
          };
        }
      ];

      services = [
        {
          Ruby = [
            {
              "Bannerfall".widget = {
                type = "minecraft";
                url = "udp://bannerfall.zerofisher.dev";
              };
            }

            {
              "Musubi Retreat".widget = {
                type = "minecraft";
                url = "udp://musubi-retreat.zerofisher.dev";
              };
            }
          ];
        }
      ];
    };
  };
}
