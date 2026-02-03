# Wayland Display Servers
{ ... }: {
  imports = [
    ./niri.nix # Scrollable-Tiling Wayland Compositor
    ./sway.nix # Tiling Wayland Compositor
  ];
}
