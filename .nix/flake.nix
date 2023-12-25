{
  description = "Bun dotfiles nix flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

    outputs = inputs@{ nixpkgs, ... }: {
    nixosConfigurations = {
      ideapad = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [ 
          ./systems/nixos.nix
          ./systems/ideapad.nix
        ];
      };
    };
  };
}
