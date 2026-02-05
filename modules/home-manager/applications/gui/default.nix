# Graphical User Interface
{ ... }: {
  imports = [
    ./anki.nix # Flashcard Program
    ./chromium.nix # Web Browser (Blink Engine)
    ./cryptomator.nix # Cloud Storage Encryption Program
    ./floorp.nix # Web Browser (Gecko Engine)
    ./geeqie.nix # Image Viewer and Organiser
    ./ludusavi.nix # Game Save Data Backup Tool
    ./nemo.nix # File Manager
    ./nextcloud.nix # File Synchronisation Client
    ./obs-studio.nix # Screen Recording and Livestreaming Software
    ./satty.nix # Screenshot Annotation Tool
    ./sober.nix # Roblox Player (Gaming Platform)
    ./thunderbird.nix # PIM Suite
    ./vesktop.nix # Discord (Social Platform)
    ./vs-code.nix # Integrated Development Environment
  ];
}
