{ pkgs, inputs, ... }: {

  imports = [
    inputs.home-manager.nixosModules.default
    ../modules/sway.nix
  ];

  users.users.bun = {
    isNormalUser = true;
    extraGroups = [ "wheel" "dialout" "docker" "video" "uucp" ];
  };
  home-manager = {
      extraSpecialArgs = { inherit inputs; };
      users = {
        "bun" = import ../users/bun.nix;
      };
  };

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-emoji
    (nerdfonts.override { fonts = [ "Iosevka" ]; })
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable networking
  networking.wireless.iwd.enable = true;
  services.connman.enable = true;
  services.connman.wifi.backend = "iwd";
  # Set your time zone.
  time.timeZone = "Europe/Copenhagen";

  # Configure keymap in X11
  services.xserver = {
    enable = true;

    autoRepeatDelay = 200;
    autoRepeatInterval = 50;

    # Keyboard
    xkb = {
      layout = "us";
      options = "caps:escape";
    };

    displayManager.sddm.enable = true;
    displayManager.sddm.theme = "chili";
    windowManager.awesome.enable = true;
  };

  virtualisation = {
    docker.enable = true;
    libvirtd.enable = true;
  };
  services.tailscale.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  environment.systemPackages = with pkgs; [
    arandr
    dconf
    dunst
    feh
    fq
    imagemagick
    libnotify
    git
    gnumake
    htop
    mako
    mpv
    openssl
    usbutils
    sddm-chili-theme
    pavucontrol 
    python311
  ];

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.redshift.enable = true;
  location = {
    longitude = 10.2;
    latitude = 56.1;
  };

  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
  };
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "23.11";
}
