{ config, pkgs, ... }:
{
  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm = {
    enable = true;
    autoSuspend = false;
  };
  services.xserver.desktopManager.gnome = {
    enable = true;
  };

  environment.systemPackages = with pkgs; [
    # gnome stuffs
    gnome3.gnome-tweaks
    gnome.adwaita-icon-theme
    gnomeExtensions.pop-shell
  ];
}
