{ pkgs, ... }: {

  imports = [ ../modules/sway.nix ];

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-emoji
    (nerdfonts.override { fonts = [ "Iosevka" ]; })
  ];

  # Enable networking
  networking.wireless.iwd.enable = true;
  networking.firewall.enable = false;

  location = {
    longitude = 10.2;
    latitude = 56.1;
  };

  # Configure keymap in X11
  services = {
    connman = {
      enable = true;
      wifi.backend = "iwd";
    };
    redshift.enable = true;

    pipewire = {
      enable = true;
      pulse.enable = true;
      alsa.enable = true;
    };

    displayManager.sddm = {
      enable = true;
      theme = "chili";
    };

    xserver = {
      enable = true;

      autoRepeatDelay = 200;
      autoRepeatInterval = 50;

      # Keyboard
      xkb = {
        layout = "us";
        options = "caps:escape";
      };

      windowManager.awesome.enable = true;
    };
  };

  programs.wireshark.enable = true;
  environment.systemPackages = with pkgs; [
    arandr
    dunst
    feh
    imagemagick
    libnotify
    mpv
    usbutils
    sddm-chili-theme
    pavucontrol

    brave
    gimp
    wezterm
    zathura
    zeal

    discord
    element-desktop
    spotify
    steam
    synergy

    freecad
    kicad
    virt-manager
  ];
}
