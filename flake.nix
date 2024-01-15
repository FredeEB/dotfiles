{
  description = "Bun dotfiles nix flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    tmux-project.url = "./modules/tmux-project";
    flake-utils.url = "github:numtide/flake-utils";
    nixgl.url = "github:nix-community/nixgl";
  };

  outputs = inputs@{ nixpkgs, home-manager, flake-utils, nixgl, ... }: {
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
        modules = [
          ./users/bun.nix
        ];
      };
    };
  };
}
