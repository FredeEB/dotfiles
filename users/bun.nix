{ pkgs, ... }:
let
  git-tools = pkgs.callPackage ../modules/git-tools/default.nix { };
  tmux-project = pkgs.callPackage ../modules/tmux-project/default.nix { };

  term = "foot";
  browser = "firefox";
in {
  programs.home-manager.enable = true;
  nixpkgs.config.allowUnfree = true;
  services.mako.enable = true;

  home = {
    username = "bun";
    homeDirectory = "/home/bun";

    sessionVariables = {
      BROWSER = browser;
      NIX_SHELL_PRESERVE_PROMPT = "1";
    };

    packages = with pkgs; [
      git-tools
      tmux-project

      bitwarden-cli
      clang-tools
      cmakeCurses
      doxygen
      gcc
      gdb
      ninja
      go
      rustup
      uv

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
      pylyzer
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
      ruff
      python3Packages.debugpy
      verible
    ];
    file = {
      ".config/nvim".source = ../configs/nvim;
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
    firefox = { enable = true; };
    foot = { enable = true; };
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
        color.pager = false;
      };
    };
    neovim = {
      enable = true;
      defaultEditor = true;
      vimdiffAlias = true;
    };
    rofi = {
      enable = true;
      terminal = "${pkgs.${term}}/bin/${term}";
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

        bind-key -n M-j  if-shell "tmux select-window -t :0" "" "new-window -t :0"
        bind-key -n M-k  if-shell "tmux select-window -t :1" "" "new-window -t :1"
        bind-key -n M-l  if-shell "tmux select-window -t :2" "" "new-window -t :2"
        bind-key -n M-\; if-shell "tmux select-window -t :3" "" "new-window -t :3"

        bind-key -n M-J  if-shell "tmux move-pane -t :0" "" "break-pane -t :0"
        bind-key -n M-K  if-shell "tmux move-pane -t :1" "" "break-pane -t :1"
        bind-key -n M-L  if-shell "tmux move-pane -t :2" "" "break-pane -t :2"
        bind-key -n M-\: if-shell "tmux move-pane -t :3" "" "break-pane -t :3"

        bind-key C-p run-shell ${tmux-project}/bin/tmux-project
        bind-key C-l run-shell ${git-tools}/bin/gl

        bind-key j split-pane -h -c "#{pane_current_path}"
        bind-key k split-pane -v -c "#{pane_current_path}"
      '';
      plugins =
        (with import ../modules/tmux.nix { inherit pkgs; }; [ nvim-movement ])
        ++ (with pkgs.tmuxPlugins; [ continuum ]);
    };
    waybar = { enable = true; };
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

  services = {
    swayidle = let 
      lockcmd = "${pkgs.swaylock}/bin/swaylock -f -i ${ ../assets/desktop.jpg }";
    in {
      enable = true;
      events = [
        { event = "before-sleep"; command = lockcmd; }
        { event = "lock"; command = lockcmd; }
      ];
      timeouts = [
        {
          timeout = 300;
          command = lockcmd;
        }
        # Lock computer
        {
          timeout = 600;
          command = "${pkgs.sway}/bin/swaymsg \"output * dpms off\"";
          resumeCommand = "${pkgs.sway}/bin/swaymsg \"output * dpms on\"";
        }
      ];
    };
  };
  wayland.windowManager.sway = let
    dbus-sway-environment = pkgs.writeTextFile {
      name = "dbus-sway-environment";
      destination = "/bin/dbus-sway-environment";
      executable = true;

      text = ''
        dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=sway
        systemctl --user stop pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
        systemctl --user start pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
      '';
    };
    mod = "Mod4";
  in {
    enable = true;
    config = {
      modifier = mod;
      terminal = term;
      input = {
        "type:keyboard" = {
          repeat_delay = "200";
          repeat_rate = "50";
          xkb_options = "caps:escape";
        };
      };
      startup = [
        { command = "${pkgs.waybar}/bin/waybar"; }
        { command = "${pkgs.swaybg}/bin/swaybg -i ${../assets/desktop.jpg}"; }
        { command = "${pkgs.mako}/bin/mako --default-timeout 4000"; }
        { command = "${pkgs.wlsunset}/bin/wlsunset -L 10.2 -l 56.2 -t 3200 -T 4500"; }
        { command = "${dbus-sway-environment}"; }
        { command = "${pkgs.sway-audio-idle-inhibit}/bin/sway-audio-idle-inhibit"; }
        { command = "configure-gtk"; }
      ];
      fonts = {
        names = [ "Iosevka Nerd Font" ];
        style = "Bold Semi";
        size = 10.0;
      };
      keybindings = {

        "${mod}+Shift+q" = "kill";

        "${mod}+Shift+p" =
          "exec ${pkgs.swaylock}/bin/swaylock -f -i ${../assets/desktop.jpg}";

        "${mod}+Return" = "exec ${pkgs.foot}/bin/foot";
        "${mod}+Shift+Return" = "exec $term -e bash";
        "${mod}+r" = "exec ${pkgs.rofi}/bin/rofi -show run";
        "${mod}+Shift+r" = "exec ${pkgs.rofi}/bin/rofi -show drun";
        "${mod}+b" = "exec ${pkgs.firefox}/bin/firefox";

        "${mod}+h" = "focus left";
        "${mod}+j" = "focus down";
        "${mod}+k" = "focus up";
        "${mod}+l" = "focus right";

        "${mod}+Shift+h" = "move left";
        "${mod}+Shift+j" = "move down";
        "${mod}+Shift+k" = "move up";
        "${mod}+Shift+l" = "move right";

        "${mod}+g" = "fullscreen toggle";
        "${mod}+t" = "layout toggle split tabbed";

        "${mod}+Shift+space" = "floating toggle";

        "${mod}+space" = "focus mode_toggle";

        "${mod}+Shift+minus" = "move scratchpad";

        "${mod}+minus" = "scratchpad show";

        "${mod}+a" = "workspace 1";
        "${mod}+s" = "workspace 2";
        "${mod}+d" = "workspace 3";
        "${mod}+f" = "workspace 4";
        "${mod}+z" = "workspace 5";
        "${mod}+x" = "workspace 6";
        "${mod}+c" = "workspace 7";
        "${mod}+v" = "workspace 8";

        "${mod}+Shift+a" = "move container to workspace 1";
        "${mod}+Shift+s" = "move container to workspace 2";
        "${mod}+Shift+d" = "move container to workspace 3";
        "${mod}+Shift+f" = "move container to workspace 4";
        "${mod}+Shift+z" = "move container to workspace 5";
        "${mod}+Shift+x" = "move container to workspace 6";
        "${mod}+Shift+c" = "move container to workspace 7";
        "${mod}+Shift+v" = "move container to workspace 8";

        "${mod}+Shift+e" = "exit";

        "${mod}+y" = "resize shrink width 10 px or 10 ppt";
        "${mod}+u" = "resize grow height 10 px or 10 ppt";
        "${mod}+i" = "resize shrink height 10 px or 10 ppt";
        "${mod}+o" = "resize grow width 10 px or 10 ppt";
      };
      window = {
        border = 1;
        titlebar = false;
      };
      floating = {
        border = 1;
        titlebar = false;
      };
      bars = [ ];
    };

    wrapperFeatures.gtk = true;
  };
  home.stateVersion = "23.11";
}
