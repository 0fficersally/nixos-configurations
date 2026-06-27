# Z Shell
{ config, lib, ... }: {
  options = {
    modules.environments.terminal.shells.zsh.enable = lib.mkEnableOption "the Zsh Unix shell";
  };

  config = lib.mkIf config.modules.environments.terminal.shells.zsh.enable {
    programs.zsh = {
      enable = true;
      dotDir = "${config.xdg.configHome}/zsh"; # Default in State Version `26.05`

      initContent = lib.mkAfter ''
        eval "$(starship init zsh)"
      '';
    };
  };
}
