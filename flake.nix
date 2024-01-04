{
  description = "Bun dotfiles nix flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-colors.url = "github:misterio77/nix-colors";
    tmux-project.url = "./modules/tmux-project";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = inputs@{ nixpkgs, home-manager, flake-utils, ... }: {
    nixosConfigurations = {
      yoga = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [ 
          ./systems/nixos.nix
          ./systems/yoga.nix
        ];
      };
      ideapad = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [ 
          ./systems/nixos.nix
          ./systems/ideapad.nix
        ];
      };
    };
    homeConfigurations = {
      bun = home-manager.lib.homeConfiguration {
        extraSpecialArgs = { inherit inputs; };
        modules = [
          ./users/bun.nix
        ];
      };
    };
  };
}
