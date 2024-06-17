{ stdenv, ... }:
stdenv.mkDerivation {
  name = "bun-nvim-config";
  src = ./.;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/nvim/config/{lua/functions,after/plugin}
    install *.lua $out/share/nvim/config/
    install lua/functions/*.lua $out/share/nvim/config/lua/functions
    install after/plugin/*lua $out/share/nvim/config/after/plugin

    runHook postInstall
  '';
}
