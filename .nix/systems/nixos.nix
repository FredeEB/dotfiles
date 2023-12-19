{ config, pkgs, home-manager, ... }: {

  imports = [
    home-manager.nixosModules.default
  ];

  users.users.bun = {
    isNormalUser = true;
    home = "/home/bun";
    extraGroups = [ "wheel" "docker" ];
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
  # networking.networkmanager.enable = true;
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

    displayManager.lightdm.enable = true;
    windowManager.awesome.enable = true;
  };

  virtualisation.docker.enable = true;
  services.tailscale.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  environment.systemPackages = with pkgs; [
    dunst
    libnotify
  ];

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "23.11";

}