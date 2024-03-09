{ pkgs, ... }: {

  imports = [
  ];

  users.users.bun = {
    isNormalUser = true;
    extraGroups = [ "wheel" "dialout" "docker" "video" "wireshark" "uucp" ];
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable networking
  networking.firewall.enable = false;
  # Set your time zone.
  time.timeZone = "Europe/Copenhagen";

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
    dconf
    fq
    git
    gnumake
    htop
    openssl
    python311
  ];

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "23.11";
}
