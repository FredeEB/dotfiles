{
    description = "tmux project selector";
    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
        flake-utils.url = "github:numtide/flake-utils";
    };
    outputs = inputs: inputs.flake-utils.lib.eachDefaultSystem (system: 
    let pkgs = inputs.nixpkgs.legacyPackages.${system}; in {
        packages.default = pkgs.stdenv.mkDerivation {
            name = "tmux-project";
            src = ./.;
            installPhase = ''
                mkdir -p $out/bin
                cp ./tmux-project $out/bin/
            '';
        };
    });
}
