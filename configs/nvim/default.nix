{ stdenv, ... }:
stdenv.mkDerivation {
  name = "bun-nvim-config";
  src = ./.;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/nvim/{lua/functions,after/plugin}
    install *.lua $out/share/nvim/
    install lua/functions/*.lua $out/share/nvim/lua/functions
    install after/plugin/*lua $out/share/nvim/after/plugin

    runHook postInstall
  '';
}
