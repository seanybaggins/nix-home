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
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.sean = import ./home/home.nix;
          }
          ({ pkgs, lib, ... }: 
          {
            nixpkgs.config.allowUnfree = true;
            nixpkgs.config.permittedInsecurePackages = [
              "python-2.7.18.6" # Required for davinci-resolve
            ];
            hardware.opengl.extraPackages = [
              pkgs.rocm-opencl-icd # Required for davinci-resolve
            ];

            nix.extraOptions = ''
              experimental-features = nix-command flakes
            '';
            users.users.sean = {
              isNormalUser = true;
              home = "/home/sean";
              description = "Sean Link";
              extraGroups = [ "wheel" "networkmanager" "audio" "video" "docker"];
              shell = pkgs.zsh;
            };
            nix.gc = {
              automatic = true;
              dates = "weekly";
              options = "--delete-older-than 15d";
            };
            services.udev.packages = with pkgs; [
              trezor-udev-rules
            ];
            
            services.xserver.displayManager = {
              setupCommands = ''
                ${pkgs.xorg.xrandr}/bin/xrandr --output eDP-1 --rotate right
              '';
              sddm = {
                enable = true;
              };
            };
            virtualisation.docker.enable = true;

             # for a WiFi printer
             services.printing.enable = true;
             services.avahi.enable = true;
             services.avahi.nssmdns = true;
             services.avahi.openFirewall = true;

            programs.zsh.enable = true;
            environment.systemPackages = with pkgs; [
              firefox
              curl
              git
              wget
            ];
            hardware.bluetooth.enable = true;
            networking.networkmanager.enable = true;
            time.timeZone = "America/Denver";
            services.xserver.xkbOptions = "caps:escape";
            services.xserver.enable = true;
            services.xserver.desktopManager.plasma5.enable = true;
            swapDevices = [ { device = "/swapfile"; size = 1024; } ];


            # Enable touchpad support
            services.xserver.libinput.enable = true;

            sound.enable = true;

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

