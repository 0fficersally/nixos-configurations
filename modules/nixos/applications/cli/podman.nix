# Container Engine
{ config, lib, ... }: {
  options = {
    modules.applications.cli.podman.enable = lib.mkEnableOption "the Podman container engine";
  };

  config = lib.mkIf config.modules.applications.cli.podman.enable {
    virtualisation.podman = {
      enable = true;
      defaultNetwork.settings.dns_enabled = true; # Bridge Network (UDP 53)
    };

    users.users.lysan.extraGroups = [ "podman" ];
  };
}
