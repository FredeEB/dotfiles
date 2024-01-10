{ pkgs, config, inputs, ... }: {
  imports = [
    inputs.nix-colors.homeManagerModules.default
  ];
  colorScheme = inputs.nix-colors.colorSchemes.tokyo-night-light;

  programs.home-manager.enable = true;

  nixpkgs.config.allowUnfree = true;

  home = {
    username = "bun";
    homeDirectory = "/home/bun";

    sessionVariables = {
      BROWSER = "firefox";
      NIX_SHELL_PRESERVE_PROMPT = "1";
      EDITOR = "nvim";
      SHELL = "bash";
      TERMINAL = "wezterm";
    };

    packages = with pkgs; [
      # TODO: something more elegant than this would be nice
      inputs.tmux-project.packages."x86_64-linux".default
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
      bat
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
    file = let mkSymlink = config.lib.file.mkOutOfStoreSymlink; in {
      ".config/awesome".source = mkSymlink ../awesome/.config/awesome;
      ".config/bash".source = mkSymlink ../bash/.config/bash;
      ".config/dunst".source = mkSymlink ../dunst/.config/dunst;
      ".config/nvim".source = mkSymlink ../nvim/.config/nvim;
      ".config/rofi".source = mkSymlink ../rofi/.config/rofi;
      ".config/tmux".source = mkSymlink ../tmux/.config/tmux;
      ".config/wezterm".source = mkSymlink ../wezterm/.config/wezterm;
    };
  };
  programs = {
    atuin = {
      enable = true;
      enableBashIntegration = true;
    };
    bash = {
      enable = true;
      shellAliases = import ../bash/aliases.nix;
      bashrcExtra = ''
        source ${../bash/.bashrc}
        export PS1="🐧\033[36m\t $(tput sgr0)\033[35m\u$(tput sgr0)@$(tput sgr0)\033[32m\h$(tput sgr0) \w$(tput sgr0) $(tput sgr0)\033[34m\$(git branch --show-current 2> /dev/null | sed -e 's/.*/ \0/') $(tput sgr0)\n"
      ''; 
    };
    readline = {
      enable = true;
      extraConfig = ''
        set completion-ignore-case On
        set show-mode-in-prompt on
        set editing-mode vi
        set keyseq-timeout 0
        set emacs-mode-string "E "
        set vi-ins-mode-string "I "
        set vi-cmd-mode-string "N "
      '';
    };
    fzf = {
      enable = true;
      enableBashIntegration = true;
      defaultOptions = [
        "--preview"
        "${pkgs.bat}/bin/bat"
        "--bind"
        "ctrl-d:preview-page-down,ctrl-u:preview-page-up"
      ];
      defaultCommand = "${pkgs.ripgrep} --files --hidden";
      tmux.enableShellIntegration = true;
      tmux.shellIntegrationOptions = ["-p" "-w" "80%" "-h" "80%"];
    };

    git = {
      enable = true;
      difftastic.enable = true;
      extraConfig = {
        user = {
          signingKey = "EEDBC8E8FC8CF68D";
          name = "Frede Braendstrup";
          email = "frederikbraendstrup@gmail.com";
        };
        commit.verbose = true;
        pull.rebase = true;
      };
    };
  };

  home.stateVersion = "23.11";
}