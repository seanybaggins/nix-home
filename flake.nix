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

  outputs = { self, nixpkgs, home-manager, jovian, nixos-hardware, ... }: {
    nixosConfigurations = {
      sean-steamdeck = nixpkgs.lib.nixosSystem { # hostname
        system = "x86_64-linux";
        modules = [
          # Import the NixOS and nixos-hardware modules
          #nixpkgs.nixosModules
          #nixos-hardware.nixosModules
          
          # Configure your system settings
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
            hardware.pulseaudio.enable = true;
            imports = [
              # Import the home-manager module
              #inputs.home-manager.nixosModules.home-manager
              
              # Import any other modules you need
              "${jovian}/modules"
            ];

            jovian = {
              steam.enable = true;
              devices.steamdeck.enable = true;
            };

            # System settings and packages
            system.stateVersion = "unstable";
            boot.loader.systemd-boot.enable = true;
            boot.loader.efi.canTouchEfiVariables = true;

            # Set your desired hostname
            networking.hostName = "sean-steamdeck";
            
            # Enable home-manager
            #programs.home-manager.enable = true;
            
            # Define a user and enable home-manager for that user
            #users.users.myuser = {
            #  isNormalUser = true;
            #  home.stateVersion = "unstable";
            #  extraGroups = [ "wheel" "networkmanager" ];
            #  shell = pkgs.zsh;
            #};
          })
        ];
      };
    };
  };
}
