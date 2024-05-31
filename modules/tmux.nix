{ pkgs, ... }:
let mkTmuxPlugin = pkgs.tmuxPlugins.mkTmuxPlugin;
in {
  nvim-movement = mkTmuxPlugin {
    name = "tmux.nvim";
    pluginName = "tmux.nvim";
    src = pkgs.fetchFromGitHub {
      owner = "aserowy";
      repo = "tmux.nvim";
      rev = "53ea7eab504730e7e8397fd2ae0133053d56afc8";
      sha256 = "sha256-P2gFopPFMYPl6Ggd40MzbVHQjdc6jLvW39u0gaN0i40=";
    };
  };
}
