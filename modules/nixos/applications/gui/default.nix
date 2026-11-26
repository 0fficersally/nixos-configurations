# Graphical User Interface
{ ... }: {
  imports = [
    ./netbird.nix # Mesh VPN Client
    ./qbittorrent.nix # BitTorrent Client
    ./steam.nix # Gaming Platform
    ./virt-manager.nix # Virtual Machine Manager
    ./windscribe.nix # Virtual Private Network
  ];
}
