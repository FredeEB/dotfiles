{ pkgs, inputs, ... }: {

  imports = [ ../modules/sway.nix inputs.stylix.nixosModules.stylix ];

  stylix = {
    enable = true;
    autoEnable = true;
    image = ../assets/desktop.jpg;
    polarity = "dark";
    base16Scheme = "${pkgs.base16-schemes}/share/themes/kanagawa.yaml";

    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
    };
    fonts = {
      serif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Serif";
      };

      sansSerif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Sans";
      };

      monospace = {
        package = pkgs.nerdfonts.override { fonts = ["Iosevka"]; };
        name = "Iosevka Nerd Font Mono";
      };

      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };
    };
  };

  # Enable networking
  networking.wireless.iwd.enable = true;
  networking.firewall.enable = false;

  location = {
    longitude = 10.2;
    latitude = 56.1;
  };

  # Configure keymap in X11
  services = {
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
    };
  };

  programs.steam.enable = true;
  environment.systemPackages = with pkgs; [
    arandr
    feh
    imagemagick
    libnotify
    mpv
    usbutils
    sddm-chili-theme
    pavucontrol

    firefox
    gimp
    zathura
    zeal
    xfce.thunar
    xfce.thunar-volman

    discord
    element-desktop
    spotify
    synergy

    freecad
    elmerfem
    gmsh
    calculix
    kicad
    virt-manager

    wireshark

    ulauncher
  ];
}
