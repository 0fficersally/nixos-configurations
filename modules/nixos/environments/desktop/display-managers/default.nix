{ ... }: {
  imports = [
    ./noctalia-greeter.nix # greetd Greeter
    ./sddm.nix # Simple Desktop Display Manager
  ];
}
