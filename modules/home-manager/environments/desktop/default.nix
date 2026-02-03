{ ... }: {
  imports = [
    ./compositors # Wayland Display Servers
    ./wpaperd.nix # Wallpaper Daemon
    ./waybar.nix # Status Bar
    ./swayosd.nix # On-Screen Display
    ./swaynotificationcenter.nix # Notification Daemon
    ./rofi.nix # Application Launcher
    ./swayidle.nix # Idle Management Daemon
    ./swaylock.nix # Screen Locking Utility
  ];
}
