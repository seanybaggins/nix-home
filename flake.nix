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
      inputs.nixpkgs.follows = "nixpkgs";
    };
    paisa = {
      url = "github:ananthakumaran/paisa";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs @ { self # Binding all function paramenters to inputs is helpful
    , nixpkgs
    , home-manager
    , jovian
    , nixos-hardware
    , ...
    }: {
      nixosConfigurations = {
        sean-steamdeck = nixpkgs.lib.nixosSystem rec {
          # Allows me to refer to flake inputs within other files 
          specialArgs = { inherit inputs; };
          system = "x86_64-linux";
          modules = [
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { inherit inputs system; };
              home-manager.users.sean = import ./home/home.nix;
              nixpkgs.overlays = [ (import ./overlays) ];
            }
            ./nixos/configuration.nix
          ];
        };
      };
    };
}
