{ pkgs, ... }: {
  home.stateVersion = "23.11";

  programs.home-manager.enable = true;
  nixpkgs.config.allowUnfree = true;

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
      gimp
      stow
      synergy
      wezterm
      zathura
      zeal
  
      cmake
      doxygen
      gcc
      ninja

      go
      rustup

      tree-sitter

      discord
      steam
      synergy

      ansible
      fzf
      neovim
      nix
      ripgrep
      rofi
      stow
      tmux
      unzip
      wget

      nodejs

      virt-manager
    ];
  };

  xdg = {
    enable = true;
    userDirs.enable = true;
    userDirs.createDirectories = true;
  };
}
