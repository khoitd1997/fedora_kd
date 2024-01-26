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

  services.gnome.gnome-keyring.enable = true;
  programs.seahorse.enable = true;

  environment.systemPackages = with pkgs; [
    i3lock
    feh
    xmobar
    rofi
  ];

  environment.etc = {
    "background.png".source = ./background.png;
    "xmobar.hs".source = ./xmobar.hs;
  };
}
