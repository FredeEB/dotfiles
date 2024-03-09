{ pkgs, inputs, ... }: {

  imports = [
    inputs.home-manager.nixosModules.default
    ../modules/sway.nix
  ];

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

  # Enable networking
  networking.wireless.iwd.enable = true;
  services.connman.enable = true;
  services.connman.wifi.backend = "iwd";

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

    firefox
    gimp
    synergy
    wezterm
    zathura
    zeal

    discord
    spotify
    steam
    synergy

    freecad
    kicad
    virt-manager
  ];

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
}
