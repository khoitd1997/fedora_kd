{ config, pkgs, ... }:
{
  # use xfce for stuffs that are not window management
  services.xserver.desktopManager = {
    xterm.enable = false;
    xfce = {
      enable = true;
      noDesktop = true;
      enableXfwm = false;
      enableScreensaver = false;
    };
  };
  services.xserver.windowManager.xmonad = {
    enable = true;
    enableContribAndExtras = true;
    enableConfiguredRecompile = true;
    extraPackages = hPkgs: [ hPkgs.xmobar ];
    config = builtins.readFile ./xmonad.hs;
  };

  services.displayManager.defaultSession = "xfce+xmonad";
  services.xserver.displayManager = {
    sessionCommands = ''
      setxkbmap -option caps:escape
    '';
  };

  location = {
    longitude = 90.0;
    latitude = 90.0;
  };
  services.redshift = {
    enable = true;
    executable = "/bin/redshift-gtk";
    temperature = {
      night = 3500;
      day = 3500;
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
