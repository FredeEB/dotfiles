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
      rev = "e34d41e4918f6e30918e03f6b930f24b0dbefc68";
      sha256 = "sha256-bosnV4IPFgLhKnf1QopzVk+RtRCDVUuILUMG4cTfStI=";
    };
  };
  nvim-movement = mkTmuxPlugin {
    name = "tmux.nvim";
    pluginName = "tmux.nvim";
    src = pkgs.fetchFromGitHub {
      owner = "aserowy";
      repo = "tmux.nvim";
      rev = "ea67d59721eb7e12144ce2963452e869bfd60526";
      sha256 = "sha256-/2flPlSrXDcNYS5HJjf8RbrgmysHmNVYYVv8z3TLFwg=";
    };
  };
}
