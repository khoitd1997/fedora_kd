{ config, pkgs, ... }:
{
  services.xserver.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };
  services.xserver.desktopManager.plasma5 = {
    enable = true;
  };

  environment.systemPackages = with pkgs; [
    konsole
    konsave
    libsForQt5.bismuth
  ];
}