{
  description = "NixOS Configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable"; # Software Repository
    nixos-hardware.url = "github:nixos/nixos-hardware/master"; # Hardware NixOS Modules

    # User Environment Declaration
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

    # Desktop Shell (Legacy)
    noctalia-v4 = {
      url = "github:noctalia-dev/noctalia/legacy-v4";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Desktop Shell (Rewrite)
    noctalia-v5 = {
      url = "github:noctalia-dev/noctalia/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Rofi Cliphist Integration
    rofi-tools = {
      url = "github:szaffarano/rofi-tools/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-flatpak.url = "github:gmodena/nix-flatpak/latest"; # Flatpak Declaration
    nixvim.url = "github:nix-community/nixvim/main"; # Neovim Configuration
    dolphin-overlay.url = "github:gipphe/dolphin-overlay/main"; # Repopulate Application List Outside Plasma

    # Visual Studio Code Extensions
    nix4vscode = {
      url = "github:nix-community/nix4vscode/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Virtual Private Network
    windscribe = {
      url = "github:syntheit/windscribe-nix/main";
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
    noctalia-v4,
    noctalia-v5,
    rofi-tools,
    nix-flatpak,
    nixvim,
    dolphin-overlay,
    nix4vscode,
    windscribe,
    nixos-secrets,
    ...
  }: {
    nixosConfigurations = {
      # Framework Laptop 16
      peridot = nixpkgs.lib.nixosSystem {
        modules = [
          nixos-hardware.nixosModules.framework-16-amd-ai-300-series
          home-manager.nixosModules.home-manager
          sops-nix.nixosModules.sops
          niri-flake.nixosModules.niri
          windscribe.nixosModules.windscribe
          ./hosts/peridot/configuration.nix

          {
            nixpkgs.overlays = [ windscribe.overlays.default ];
            modules.hardware.gpus.amd.enable = true;
            boot.initrd.luks.devices.luks-68cd8be7-08ff-45ad-a888-a23dc0800fed.device = "/dev/disk/by-uuid/68cd8be7-08ff-45ad-a888-a23dc0800fed"; # Swap Encryption

            fileSystems."/mnt/Games" = {
              device = "/dev/disk/by-uuid/a592a002-3d83-44ff-a293-60884e4b2cf3";
              fsType = "ext4";
              options = [ "defaults" "nofail" ];
            };

            home-manager = {
              useUserPackages = true;
              sharedModules = [ sops-nix.homeManagerModules.sops ];

              users.lysan.imports = [
                noctalia-v4.homeModules.default
                noctalia-v5.homeModules.default
                nixvim.homeModules.nixvim
                nix-flatpak.homeManagerModules.nix-flatpak
                ./hosts/peridot/home-configuration.nix
              ];

              extraSpecialArgs = { inherit self rofi-tools dolphin-overlay nix4vscode nixos-secrets; };
            };
          }
        ];

        specialArgs = { inherit nixos-secrets; };
      };
    };
  };
}
