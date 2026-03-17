{
  description = "NixOS Configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable"; # Packages
    nixos-hardware.url = "github:nixos/nixos-hardware/master"; # Hardware Modules

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
  };

  outputs = inputs@{
    self,
    nixpkgs,
    nixos-hardware,
    home-manager,
    sops-nix,
    niri-flake,
    rofi-tools,
    nixvim,
    nix-flatpak,
    nix4vscode,
    nixos-secrets,
    ...
  }: {
    nixosConfigurations = {
      # Framework Laptop 16
      aurora = nixpkgs.lib.nixosSystem {
        modules = [
          sops-nix.nixosModules.sops
          niri-flake.nixosModules.niri
          ./hosts/aurora/configuration.nix
          nixos-hardware.nixosModules.framework-16-amd-ai-300-series
          home-manager.nixosModules.home-manager

          {
            boot.initrd.luks.devices.luks-68cd8be7-08ff-45ad-a888-a23dc0800fed.device = "/dev/disk/by-uuid/68cd8be7-08ff-45ad-a888-a23dc0800fed"; # Disk Encryption

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
    };
  };
}
