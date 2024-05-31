{
  description = "Bun dotfiles nix flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    nixgl.url = "github:nix-community/nixgl";
    stylix.url = "github:danth/stylix";
  };

  outputs = inputs@{ nixpkgs, ... }:
    let
      base = [ ./common/base.nix ];
      createSystem = (system-file:
        let name = nixpkgs.lib.strings.removeSuffix ".nix" system-file;
        in {
          inherit name;
          value = nixpkgs.lib.nixosSystem {
            specialArgs = { inherit inputs; };
            modules = base ++ [ (./systems + "/${system-file}") ];
          };
        });
    in {
      nixosConfigurations = builtins.listToAttrs
        (map createSystem (builtins.attrNames (builtins.readDir ./systems)));

      formatter."x86_64-linux" = nixpkgs.legacyPackages."x86_64-linux".nixfmt;
    };
}
