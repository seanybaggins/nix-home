{
  description = "System configurations for all of my personal machines";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    jovian = {
      url = "github:Jovian-Experiments/Jovian-NixOS";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, home-manager, jovian, nixos-hardware }: {
    nixosConfigurations = {
      sean-steamdeck = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ({ pkgs, lib, ... }: {
            nixpkgs.config.allowUnfree = true;
            nix.extraOptions = ''
              experimental-features = nix-command flakes
            '';
            hardware.bluetooth.enable = true;
            networking.networkmanager.enable = true;
            time.timeZone = "America/Denver";
            services.xserver.xkbOptions = "caps:escape";
            services.xserver.enable = true;
            services.xserver.displayManager.sddm.enable = true;
            services.xserver.desktopManager.plasma5.enable = true;
            services.printing.enable = true;
            swapDevices = [ { device = "/swapfile"; size = 1024; } ];

            # Enable touchpad support
            services.xserver.libinput.enable = true;

            sound.enable = true;
            #hardware.pulseaudio.enable = true;

            imports = [
              "${jovian}/modules"
              ./machines/steam.nix
            ];

            jovian = {
              steam.enable = true;
              devices.steamdeck.enable = true;
            };

            system.stateVersion = "unstable";
            boot.loader.systemd-boot.enable = true;
            boot.loader.efi.canTouchEfiVariables = true;
            networking.hostName = "sean-steamdeck";
            fileSystems = {
              "/" = {
                device = "/dev/disk/by-label/nixos";
                fsType = "ext4";
                autoResize = true;
              };

              "/boot" = {
                device = "/dev/disk/by-label/boot";
                fsType = "vfat";
              };
            };

          })
        ];
      };
    };
  };
}

