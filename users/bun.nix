{ pkgs, config, inputs, ... }:
 let
    tmux-project = pkgs.callPackage ../modules/tmux-project/default.nix {};
    git-tools = pkgs.callPackage ../modules/git-tools/default.nix {};
in {
  gtk = {
    enable = true;
    cursorTheme = {
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Ice";
    };
    theme = {
        package = pkgs.adw-gtk3;
        name = "adw-gtk3";
    };
  };

  qt.platformTheme = "gtk";
  qt.style = {
    name = "adwaita-dark";
    package = pkgs.adwaita-qt;
  };

  programs.home-manager.enable = true;

  nixpkgs.config.allowUnfree = true;

  services.gpg-agent = {
    enable = true;
    enableBashIntegration = true;
    enableSshSupport = true;
    pinentryFlavor = "qt";
    enableScDaemon = true;
  };

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
      tmux-project
      git-tools
      
      firefox
      gimp
      stow
      synergy
      wezterm
      zathura
      zeal
    
      clang-tools
      cmake
      doxygen
      gcc
      ninja
      go
      rustup

      tree-sitter

      discord
      spotify
      steam
      synergy

      blender
      freecad
      kicad

      ansible
      bat
      fzf
      neovim
      nix
      ripgrep
      rofi
      stow
      unzip
      wget

      nodejs

      nodePackages.bash-language-server
      bashdb
      docker-compose-language-service
      hadolint
      gopls
      luajitPackages.lua-lsp
      nil
      neocmakelsp
      pylyzer

      virt-manager
    ];
    file = let mkSymlink = config.lib.file.mkOutOfStoreSymlink; in {
      ".config/awesome".source = mkSymlink ../configs/awesome;
      ".config/dunst".source = mkSymlink ../configs/dunst;
      ".config/nvim".source = mkSymlink ../configs/nvim;
      ".config/rofi".source = mkSymlink ../configs/rofi;
      ".config/sway".source = mkSymlink ../configs/sway;
      ".config/wezterm".source = mkSymlink ../configs/wezterm;

      ".config/gdb/gdbinit".source = pkgs.writeText "gdbinit" ''
        set auto-load safe-path /
      '';
    };
  };
  programs = {
    bash = {
      enable = true;
      shellAliases = import ../configs/bash/aliases.nix;
      bashrcExtra = ''
        source ${../configs/bash/.bashrc}
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
        push.default = "upstream";
      };
    };
    tmux = {
      enable = true;
      extraConfig = ''
        set -g set-clipboard on
        set -sg escape-time 0
        set -g mouse
        set -sa terminal-overrides ',xterm-256color:RGB'
        set -g default-terminal 'tmux-256color'
        set -g focus-events on
        set -g history-limit 20000
        set -g status-position bottom
        set -g status-left-length 100
        set -wg mode-keys vi

        bind-key C-p run-shell ${tmux-project}/bin/tmux-project
        bind-key C-l run-shell ${git-tools}/bin/gl

        bind-key j split-pane -h -c "#{pane_current_path}"
        bind-key k split-pane -v -c "#{pane_current_path}"
      '';
      plugins = with import ../modules/tmux.nix { inherit pkgs; }; [
        tokyo-night-tmux
        nvim-movement
      ];
    };
  };

  home.stateVersion = "23.11";
}
