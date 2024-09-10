{ pkgs, config, ... }:
let
  tmux-project = pkgs.callPackage ../modules/tmux-project/default.nix { };
  git-tools = pkgs.callPackage ../modules/git-tools/default.nix { };
in {
  programs.home-manager.enable = true;

  nixpkgs.config.allowUnfree = true;

  services.mako.enable = true;

  home = {
    username = "bun";
    homeDirectory = "/home/bun";

    sessionVariables = {
      DESKTOP_WALLPAPER_PATH = ../assets/desktop.jpg;
      BROWSER = "firefox";
      NIX_SHELL_PRESERVE_PROMPT = "1";
      SHELL = "bash";
      TERMINAL = "wezterm";
    };

    packages = with pkgs; [
      tmux-project
      git-tools

      bitwarden-cli
      clang-tools
      cmakeCurses
      doxygen
      gcc
      gdb
      ninja
      go
      rustup

      tree-sitter

      ansible
      bat
      fzf
      nix
      ripgrep
      unzip
      wget
      vim

      nodejs

      bitbake-language-server
      bash-language-server
      pyright
      nodePackages.typescript-language-server
      black
      bashdb
      dockerfile-language-server-nodejs
      docker-compose-language-service
      terraform-ls
      hadolint
      gopls
      lua-language-server
      nixd
      neocmakelsp
      python3Packages.debugpy
    ];
    file = {
      ".config/nvim".source = ../configs/nvim;
      ".config/sway".source = ../configs/sway;
      ".ssh/rc".source = ../configs/ssh/rc;

      ".config/gdb/gdbinit".source = pkgs.writeText "gdbinit" ''
        set auto-load safe-path /
      '';
    };
  };
  programs = {
    atuin = {
      enable = true;
      enableBashIntegration = true;
      settings = {
        style = "compact";
        inline_height = 20;
        enter_accept = false;
        keymap_mode = "vim-insert";
      };
      flags = [ "--disable-up-arrow" ];
    };
    bash = {
      enable = true;
      shellAliases = import ../configs/bash/aliases.nix;
      bashrcExtra = ''
        source ${pkgs.fzf}/share/fzf/completion.bash
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
      enableBashIntegration = false;
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
        fetch.parallel = 0;
        pull.rebase = true;
        pull.autoSquash = true;
        pull.autoStash = true;
        push.default = "upstream";
        push.autoSetupRemote = true;
        push.useForceIfIncludes = true;
        rerere.enabled = true;
      };
    };
    neovim = {
      enable = true;
      defaultEditor = true;
      vimdiffAlias = true;
    };
    tmux = {
      enable = true;
      extraConfig = ''
        set -g set-clipboard on
        set -sg escape-time 0
        set -g mouse
        set -g focus-events on
        set -g history-limit 20000
        set -g status-position bottom
        set -g status-left-length 100
        set -g default-terminal "tmux-256color"
        set -ga terminal-overrides ",*256col*:Tc"
        set -ga terminal-overrides '*:Ss=\E[%p1%d q:Se=\E[ q'
        set-environment -g 'SSH_AUTH_SOCK' ~/.ssh/ssh_auth_sock
        set-environment -g COLORTERM "truecolor"
        set -wg mode-keys vi

        bind-key C-p run-shell ${tmux-project}/bin/tmux-project
        bind-key C-l run-shell ${git-tools}/bin/gl

        bind-key j split-pane -h -c "#{pane_current_path}"
        bind-key k split-pane -v -c "#{pane_current_path}"
      '';
      plugins =
        (with import ../modules/tmux.nix { inherit pkgs; }; [ nvim-movement ])
        ++ (with pkgs.tmuxPlugins; [ continuum ]);
    };
    waybar = {
      enable = true;
    };
    wezterm = {
      enable = true;
      extraConfig = ''
        local wezterm = require('wezterm')

        function tmux_running()
            local handle = io.popen('tmux list-sessions')
            if handle == nil then
                print('failed running tmux')
                return false
            end
            return handle:read('l') ~= nil
        end

        function tmux_command()
            local command = {'tmux'}
            if tmux_running() then
                table.insert(command, 'a')
            end
            return command
        end

        local config = {}
        if wezterm.config_builder then
          config = wezterm.config_builder()
        end

        config.harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' }
        config.window_padding = { left = 0, right = 0, top = 0, bottom = 0 }
        config.enable_tab_bar = false

        config.default_prog = tmux_command()
        return config
      '';
    };
  };

  home.stateVersion = "23.11";
}
