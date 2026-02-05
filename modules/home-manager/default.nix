# Home Manager Modules
{ ... }: {
  imports = [
    ./daemons # User Background Processes
    ./environments # User Sessions
    ./applications
    ./appearance # UI Customisation
  ];
}
