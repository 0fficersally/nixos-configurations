# Minecraft Launcher
{ config, lib, pkgs, ... }: {
  options = {
    modules.applications.gui.prismLauncher.enable = lib.mkEnableOption "the Prism Launcher Minecraft launcher";
  };

  config = lib.mkIf config.modules.applications.gui.prismLauncher.enable {
    programs.prismlauncher = {
      enable = true;

      # [Workaround](https://discourse.nixos.org/t/java-filechooser-glib-gio-error/69381)
      package = pkgs.symlinkJoin {
        name = "prismlauncher-wrapped";
        paths = [ pkgs.prismlauncher ];
        nativeBuildInputs = [ pkgs.makeWrapper ];

        postBuild = ''
          wrapProgram $out/bin/prismlauncher \
            --suffix XDG_DATA_DIRS : "${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}" \
            --suffix XDG_DATA_DIRS : "${pkgs.gtk3}/share/gsettings-schemas/${pkgs.gtk3.name}"
        '';
      };
    };
  };
}
