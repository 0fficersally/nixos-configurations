# Terminal User Interface
{ ... }: {
  imports = [
    ./btop.nix # Resource Monitor
    ./cava.nix # Audio Visualiser
    ./lazygit.nix # Git Client
    ./neovim.nix # Text Editor
    ./rmpc.nix # MPD Client
    ./wiremix.nix # PipeWire Audio Mixer
    ./yazi.nix # File Manager
  ];
}
