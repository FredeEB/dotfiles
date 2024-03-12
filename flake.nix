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
  };

  outputs =
    inputs@{ nixpkgs, home-manager, nixgl, neovim-nightly-overlay, ... }:
    let
      overlays = [ neovim-nightly-overlay.overlay ];

      base = [ { nixpkgs.overlays = overlays; } ./systems/base.nix ];
    in {
      nixosConfigurations = {
        dt = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = base ++ [ ./systems/desktop.nix ./systems/dt.nix ];
        };
        yoga = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = base ++ [ ./systems/desktop.nix ./systems/yoga.nix ];
        };
        ideapad = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = base ++ [ ./systems/desktop.nix ./systems/ideapad.nix ];
        };
        server = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = base ++ [ ./systems/server.nix ./modules/ssh.nix ];
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
