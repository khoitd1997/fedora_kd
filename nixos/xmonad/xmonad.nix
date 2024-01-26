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
