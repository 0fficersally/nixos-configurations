{
  description = "NixOS Configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable"; # Packages

    # User Environments
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Secret Provisioning
    sops-nix = {
      url = "github:mic92/sops-nix/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Scrollable-Tiling Wayland Compositor
    niri-flake = {
      url = "github:sodiboo/niri-flake/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Rofi Cliphist Integration
    rofi-tools = {
      url = "github:szaffarano/rofi-tools/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Neovim Configuration
    nixvim = {
      url = "github:nix-community/nixvim/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-flatpak.url = "github:gmodena/nix-flatpak/latest"; # Flatpak Declaration

    # Visual Studio Code Extensions
    nix4vscode = {
      url = "github:nix-community/nix4vscode/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # SOPS Secrets
    nixos-secrets = {
      flake = false;
      url = "git+ssh://git@github.com/0fficersally/nixos-secrets.git?ref=main&shallow=1";
    };

    # Reverse Proxy
    caddy-compose = {
      flake = false;
      url = "git+ssh://git@github.com/0fficersally/caddy-compose.git?ref=main&shallow=1";
    };

    # Software Forge
    forgejo-compose = {
      flake = false;
      url = "git+ssh://git@github.com/0fficersally/forgejo-compose.git?ref=main&shallow=1";
    };

    # Photo and Video Management Server
    immich-compose = {
      flake = false;
      url = "git+ssh://git@github.com/0fficersally/immich-compose.git?ref=main&shallow=1";
    };

    # Java Edition Servers
    minecraft-compose = {
      flake = false;
      url = "git+ssh://git@github.com/0fficersally/minecraft-compose.git?ref=main&shallow=1";
    };

    # Cloud Suite Server
    nextcloud-compose = {
      flake = false;
      url = "git+ssh://git@github.com/0fficersally/nextcloud-compose.git?ref=main&shallow=1";
    };

    # Photography Website
    photography-fontyn = {
      flake = false;
      url = "git+ssh://git@github.com/jjbessa/photography-fontyn.git?ref=main&shallow=1";
    };

    # Internet Metasearch Engine
    searxng-compose = {
      flake = false;
      url = "git+ssh://git@github.com/zero-fisher/searxng-compose.git?ref=main&shallow=1";
    };

    # WakaTime Back End
    wakapi-compose = {
      flake = false;
      url = "git+ssh://git@github.com/0fficersally/wakapi-compose.git?ref=main&shallow=1";
    };
  };

  outputs = inputs@{
    self,
    nixpkgs,
    home-manager,
    sops-nix,
    niri-flake,
    rofi-tools,
    nixvim,
    nix-flatpak,
    nix4vscode,
    nixos-secrets,
    caddy-compose,
    forgejo-compose,
    immich-compose,
    minecraft-compose,
    nextcloud-compose,
    photography-fontyn,
    searxng-compose,
    wakapi-compose,
    ...
  }: {
    nixosConfigurations = {
      aurora = nixpkgs.lib.nixosSystem {
        modules = [
          ./hosts/aurora/configuration.nix
          home-manager.nixosModules.home-manager
          sops-nix.nixosModules.sops
          niri-flake.nixosModules.niri

          {
            hardware.nvidia.prime = {
              intelBusId = "PCI:0:2:0"; # Integrated
              nvidiaBusId = "PCI:1:0:0"; # Discrete
            };

            home-manager = {
              sharedModules = [ sops-nix.homeManagerModules.sops ];

              users.lysan.imports = [
                ./hosts/aurora/home-configuration.nix
                nixvim.homeModules.nixvim
                nix-flatpak.homeManagerModules.nix-flatpak

                {
                  nixpkgs.overlays = [ nix4vscode.overlays.default ];
                }
              ];

              extraSpecialArgs = { inherit self rofi-tools nixos-secrets; };
            };
          }
        ];

        specialArgs = { inherit nixos-secrets; };
      };

      quasar = nixpkgs.lib.nixosSystem {
        modules = [
          ./hosts/quasar/configuration.nix
          home-manager.nixosModules.home-manager
          sops-nix.nixosModules.sops

          {
            home-manager = {
              sharedModules = [ sops-nix.homeManagerModules.sops ];

              users.lysan.imports = [
                ./hosts/quasar/home-configuration.nix
                nixvim.homeModules.nixvim
              ];

              extraSpecialArgs = { inherit self nixos-secrets; };
            };
          }
        ];

        specialArgs = {
          inherit
            nixos-secrets
            caddy-compose
            forgejo-compose
            immich-compose
            minecraft-compose
            nextcloud-compose
            photography-fontyn
            searxng-compose
            wakapi-compose
          ;
        };
      };
    };
  };
}
