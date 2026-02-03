# NixOS Modules
{ ... }: {
  imports = [
    ./hardware # Hardware Components
    ./applications
  ];
}
