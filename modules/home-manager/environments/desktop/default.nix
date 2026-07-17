{ ... }: {
  imports = [
    ./compositors # Wayland Display Servers
    ./shells # Desktop Shells
    ./wpaperd.nix # Wallpaper Daemon
    ./waybar.nix # Status Bar
    ./swayosd.nix # Hotkey Action OSD
    ./swaynotificationcenter.nix # Notification Daemon
    ./rofi.nix # Application Launcher
    ./swayidle.nix # Idle Management Daemon
    ./swaylock.nix # Screen Locking Utility
  ];
}
