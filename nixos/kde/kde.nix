{ config, pkgs, ... }:
{
  services.xserver.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };
  services.xserver.desktopManager.plasma5 = {
    enable = true;
    supportDDC = true;
  };

  environment.systemPackages = with pkgs; [
    konsole
    konsave
  ];
}