{ pkgs, ... }:
let mkTmuxPlugin = pkgs.tmuxPlugins.mkTmuxPlugin;
in {
  tokyo-night-tmux = mkTmuxPlugin {
    name = "tokyo-night-tmux";
    pluginName = "tokyo-night-tmux";
    rtpFilePath = "tokyo-night.tmux";
    src = pkgs.fetchFromGitHub {
      owner = "janoamaral";
      repo = "tokyo-night-tmux";
      rev = "v1.5";
      sha256 = "sha256-yho2irPSwdRkNNwU7HZzN5dvspjDHWl75NlpS3uwz8M=";
    };
  };
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
