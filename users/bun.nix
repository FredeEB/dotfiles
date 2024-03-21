{ pkgs, config, ... }:
let
  tmux-project = pkgs.callPackage ../modules/tmux-project/default.nix { };
  git-tools = pkgs.callPackage ../modules/git-tools/default.nix { };
in {
  programs.home-manager.enable = true;

  nixpkgs.config.allowUnfree = true;

  services = {
    gpg-agent = {
      enable = true;
      enableBashIntegration = true;
      enableSshSupport = true;
      enableScDaemon = true;
    };
    mako = {
      enable = true;
      backgroundColor = "#24283b";
      textColor = "#c0caf5";
      borderRadius = 5;
      borderSize = 0;
      layer = "overlay";
      defaultTimeout = 4000;
    };
  };

  home = {
    username = "bun";
    homeDirectory = "/home/bun";
    pointerCursor = {
      gtk.enable = true;
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 22;
    };

    sessionVariables = {
      BROWSER = "brave";
      NIX_SHELL_PRESERVE_PROMPT = "1";
      EDITOR = "nvim";
      SHELL = "bash";
      TERMINAL = "wezterm";
    };

    packages = with pkgs; [
      tmux-project
      git-tools

      clang-tools
      cmake
      doxygen
      gcc
      ninja
      go
      rustup

      tree-sitter

      ansible
      bat
      fzf
      nix
      ripgrep
      rofi
      stow
      unzip
      wget

      nodejs

      nodePackages.bash-language-server
      nodePackages.pyright
      bashdb
      docker-compose-language-service
      hadolint
      gopls
      luajitPackages.lua-lsp
      nil
      neocmakelsp
    ];
    file = let mkSymlink = config.lib.file.mkOutOfStoreSymlink;
    in {
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
        source ${../configs/bash/bashrc}
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
      defaultCommand = "${pkgs.ripgrep} --files";
      tmux.enableShellIntegration = true;
      tmux.shellIntegrationOptions = [ "-p" "-w" "80%" "-h" "80%" ];
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
        pull.autoSquash = true;
        pull.autoStash = true;
        push.default = "upstream";
        rerere.enabled = true;
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

        bind-key -n M-j select-window -t 0
        bind-key -n M-k select-window -t 1
        bind-key -n M-l select-window -t 2
        bind-key -n M-\; select-window -t 3

        bind-key j split-pane -h -c "#{pane_current_path}"
        bind-key k split-pane -v -c "#{pane_current_path}"
      '';
      plugins = (with import ../modules/tmux.nix { inherit pkgs; }; [
        tokyo-night-tmux
        nvim-movement
      ]) ++ (with pkgs.tmuxPlugins; [ continuum ]);
    };
  };

  home.stateVersion = "23.11";
}
