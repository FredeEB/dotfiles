{
  description = "Bun dotfiles nix flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:nixos/nixos-hardware";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dotfiles = {
      url = "github:fredeeb/dotfiles";
      flake = false;
    };
    themes = {
      url = "github:rgbcube/themenix";
      flake = true;
    };
  };

  outputs = inputs@{ nixpkgs, dotfiles, themes, nixos-hardware, home-manager, ... }:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs { inherit system; };
  in {
    theme = themes.tokyo-night-dark;
    nixosConfigurations = {
      ideapad = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [ 
          ./systems/nixos.nix
          ./systems/ideapad.nix
        ];
        specialArgs = inputs;
      };
    };
    homeConfigurations = {
      bun = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ ./users/bun.nix ];
        extraSpecialArgs = { inherit inputs; };
      };
    };
  };
}
