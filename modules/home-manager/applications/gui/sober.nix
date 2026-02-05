# Roblox Player (Gaming Platform)
{ config, lib, nix-flatpak, ... }: {
  options = {
    modules.applications.gui.sober.enable = lib.mkEnableOption "the Sober interoperability layer for running Roblox Player";
  };

  config = lib.mkIf config.modules.applications.gui.sober.enable {
    services.flatpak = {
      packages = [ "org.vinegarhq.Sober" ];

      overrides."org.vinegarhq.Sober".Context = {
        devices = [ "input" ];

        filesystems = [
          "xdg-run/app/com.discordapp.Discord:create"
          "xdg-run/discord-ipc-0"
        ];
      };
    };
  };
}
