{ config, pkgs, ... }:
{
  services.xserver.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  services.xserver.windowManager.xmonad = {
    enable = true;
    enableContribAndExtras = true;
    enableConfiguredRecompile = true;
    extraPackages = hPkgs: [ hPkgs.xmobar ];
    config = builtins.readFile ./xmonad.hs;
  };

  services.xserver.displayManager.sessionCommands = ''
    setxkbmap -option caps:escape
  '';

  location = {
    longitude = 90.0;
    latitude = 90.0;
  };
  services.redshift = {
    enable = true;
    temperature = {
      night = 4500;
      day = 4500;
    };
  };

  services.gnome.gnome-keyring.enable = true;
  programs.seahorse.enable = true;

  environment.systemPackages = with pkgs; [
    i3lock
    feh
    xmobar
    rofi
    networkmanagerapplet
    pavucontrol
    trayer
    pamixer
    i3status-rust
    volctl
  ];

  environment.etc = {
    "background.png".source = ./background.png;
    "xmobar.hs".source = ./xmobar.hs;
  };
}
