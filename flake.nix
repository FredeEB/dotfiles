{
  description = "Bun dotfiles nix flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixgl.url = "github:nix-community/nixgl";
  };

  outputs = inputs@{ nixpkgs, home-manager, nixgl, ... }: {
    nixosConfigurations = {
      dt = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [ ./systems/base.nix ./systems/desktop.nix ./systems/dt.nix ];
      };
      yoga = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules =
          [ ./systems/base.nix ./systems/desktop.nix ./systems/yoga.nix ];
      };
      ideapad = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules =
          [ ./systems/base.nix ./systems/desktop.nix ./systems/ideapad.nix ];
      };
      server = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [ ./systems/base.nix ./systems/server.nix ./modules/ssh.nix ];
      };
    };
    homeConfigurations = let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ nixgl.overlay ];
      };
    in {
      bun = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = { inherit inputs; };
        modules = [ ./users/bun.nix ];
      };
    };

    formatter."x86_64-linux" = nixpkgs.legacyPackages."x86_64-linux".nixfmt;
  };
}
