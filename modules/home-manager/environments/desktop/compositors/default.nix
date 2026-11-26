# Wayland Display Servers
{ ... }: {
  imports = [
    ./niri.nix # Scrollable-Tiling Wayland Compositor
    ./umbriel.nix
  ];
}
