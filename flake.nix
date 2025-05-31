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
    #paisa = {
    #  url = "github:ananthakumaran/paisa";
    #  inputs.nixpkgs.follows = "nixpkgs";
    #};
    caligula = {
      url = "github:ifd3f/caligula";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    xrlinuxdriver = {
      url = "github:shymega/XRLinuxDriver?ref=shymega/nix-flake-support";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self, # Binding all function paramenters to inputs is helpful
      nixpkgs,
      home-manager,
      jovian,
      nixos-hardware,
      caligula,
      ...
    }:
    {

      supportedSystem = "x86_64-linux";

      nixosConfigurations = {
        sean-steamdeck = nixpkgs.lib.nixosSystem rec {
          # Allows me to refer to flake inputs within other files
          specialArgs = { inherit inputs; };
          system = self.supportedSystem;
          modules = [
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { inherit inputs system; };
              home-manager.users.sean = import ./home/home.nix;
              nixpkgs.overlays = [
                (import ./overlays)
                inputs.xrlinuxdriver.overlays.default
              ];
            }
            ./nixos/configuration.nix
          ];
        };
      };

      overlays.default = (import ./overlays);

      packages.x86_64-linux.pkgs = import nixpkgs {
        overlays = [
          self.overlays.default
          inputs.xrlinuxdriver.overlays.default
        ];
        system = self.supportedSystem;
      };
    };
}
