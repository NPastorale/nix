{
  description = "Nahuel's Nix config (nix-darwin + NixOS + home-manager)";

  inputs = {
    # nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    nix-darwin = {
      # url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      # url = "github:nix-community/home-manager/release-26.05";
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nix-darwin,
      home-manager,
      ...
    }:
    {
      darwinConfigurations.air = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";

        modules = [
          (import ./modules/common.nix)
          home-manager.darwinModules.home-manager
          {
            imports = [ ./hosts/air/configuration.nix ];
            home-manager.users.nahue = import ./home-manager/nahue.nix;
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
          }
        ];
      };

      nixosConfigurations.xps = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        modules = [
          (import ./modules/common.nix)
          home-manager.nixosModules.home-manager
          {
            imports = [ ./hosts/xps/configuration.nix ];
            home-manager.users.nahue = import ./home-manager/nahue.nix;
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
          }
        ];
      };
    };
}
