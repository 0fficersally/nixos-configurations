{ ... }: {
  imports = [
    ./kitty.nix # Terminal Emulator
    ./shells # Command-Line Interpreters
    ./starship.nix # Cross-Shell Prompt
  ];
}
