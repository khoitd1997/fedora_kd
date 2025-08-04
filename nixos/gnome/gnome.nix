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
    gnome-tweaks
    adwaita-icon-theme
    gnomeExtensions.pop-shell
    gnomeExtensions.appindicator
    dconf2nix
  ];
}
