# NixOS Modules
{ ... }: {
  imports = [
    ./specialisations
    ./hardware # Hardware Components
    ./environments # User Sessions
    ./applications
  ];
}
