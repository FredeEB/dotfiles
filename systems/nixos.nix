{ config, pkgs, home-manager, ... }:
{
  imports = [
    home-manager.nixosModules.default
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos";

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
    layout = "us";
    xkbVariant = "";
    displayManager.lightdm.enable = true;
    windowManager.awesome.enable = true;
  };

  virtualisation.docker.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "23.11";

}
