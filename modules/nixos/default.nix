# NixOS Modules
{ ... }: {
  imports = [
    ./hardware # Hardware Components
    ./applications
    ./containers # Provided Services
  ];
}
