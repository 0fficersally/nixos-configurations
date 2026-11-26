# greetd Greeter
{ config, lib, ... }: {
  options = {
    modules.environments.desktop.displayManagers.noctaliaGreeter.enable = lib.mkEnableOption "the Noctalia Greeter for greetd";
  };

  config = lib.mkIf config.modules.environments.desktop.displayManagers.noctaliaGreeter.enable {
    services.displayManager = {
      enable = true;

      noctalia-greeter = {
        enable = true;

        settings = {
          keyboard.layout = "be";
        };
      };
    };
  };
}
