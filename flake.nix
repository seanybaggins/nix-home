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
      ...
    }:
    {

      supportedSystem = "x86_64-linux";

      nixosConfigurations = {
        sean-steamdeck = inputs.nixpkgs.lib.nixosSystem rec {
          # Allows me to refer to flake inputs within other files
          specialArgs = { inherit inputs; };
          system = inputs.self.supportedSystem;
          modules = [
            inputs.home-manager.nixosModules.home-manager
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

      packages.x86_64-linux.pkgs = import inputs.nixpkgs {
        overlays = [
          inputs.self.overlays.default
          inputs.xrlinuxdriver.overlays.default
        ];
        system = inputs.self.supportedSystem;
      };
    };
}
