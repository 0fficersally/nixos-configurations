# Provided Services
{ ... }: {
  imports = [
    ./caddy.nix # Reverse Proxy
    ./forgejo.nix # Software Forge
    ./immich.nix # Photo and Video Management Server
    ./minecraft.nix # Java Edition Servers
    ./nextcloud.nix # Cloud Suite Server
    ./photography-fontyn.nix # Photography Website
    ./searxng.nix # Internet Metasearch Engine
    ./wakapi.nix # WakaTime Back End
  ];
}
