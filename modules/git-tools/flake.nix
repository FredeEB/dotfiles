{
    description = "Bun's git tools";
    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
        flake-utils.url = "github:numtide/flake-utils";
    };

    outputs = { nixpkgs, flake-utils, ... }: flake-utils.lib.eachDefaultSystem (system:
    let pkgs = import nixpkgs {inherit system;}; in {
        packages.default = pkgs.stdenv.mkDerivation {
            name = "git-tools";
            src = ./git-tools;
            installPhase = ''
                mkdir -p $out/bin
                cp ./* $out/bin/
            '';
        };
    });
}
