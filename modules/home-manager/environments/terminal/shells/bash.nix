# Bourne Again Shell
{ config, lib, ... }: {
  options = {
    modules.environments.terminal.shells.bash.enable = lib.mkEnableOption "the Bash Unix shell";
  };

  config = lib.mkIf config.modules.environments.terminal.shells.bash.enable {
    programs.bash = {
      enable = true;

      bashrcExtra = lib.mkAfter ''
        eval "$(starship init bash)"
      '';
    };
  };
}
