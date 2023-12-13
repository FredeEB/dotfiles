args@{ self, config, lib, inputs, pkgs, ... }:
  let 
    username = "bun";
  in
{
  home.stateVersion = "23.11";

  programs.home-manager.enable = true;

  home = {
    username = username;
    homeDirectory = "/home/${username}";
    sessionVariables = {
      BROWSER = "firefox";
      TERMINAL = "wezterm";
      EDITOR = "nvim";
    };

    packages = with pkgs; [
      firefox
      neovim
      tmux
      wezterm
  
      nix
      git
      virt-manager
      steam
    ];

  };

  xdg = {
    enable = true;
    userDirs.enable = true;
    userDirs.createDirectories = true;
  };
}
