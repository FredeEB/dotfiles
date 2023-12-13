{ self, config, lib, inputs, pkgs, ... }: {
  home.stateVersion = "23.11";

  programs.home-manager.enable = true;

  home = {
    username = "bun";
    homeDirectory = "/home/bun";

    sessionVariables = {
      BROWSER = "firefox";
      EDITOR = "nvim";
      SHELL = "bash";
      TERMINAL = "wezterm";
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
