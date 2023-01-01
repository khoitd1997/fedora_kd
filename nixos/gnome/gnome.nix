{ config, pkgs, ... }:
{
  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm = {
    enable = true;
  };
  services.xserver.desktopManager.gnome = {
    enable = true;
  };

  environment.systemPackages = with pkgs; [
    gnome3.gnome-tweaks
    gnome.adwaita-icon-theme
    gnomeExtensions.pop-shell
    gnomeExtensions.appindicator
  ];
}
