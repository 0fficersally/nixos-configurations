# Command-Line Interface
{ ... }: {
  imports = [
    ./bat.nix # File Viewer
    ./fastfetch.nix # System Information Fetcher
    ./git.nix # Version Control System
    ./github.nix # GitHub Command-Line Tool
    ./openssh.nix # Secure Shell Client
    ./rbw.nix # Bitwarden (Password Manager)
    ./whipper.nix # CD-DA Ripper
  ];
}
