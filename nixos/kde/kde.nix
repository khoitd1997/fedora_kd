{ config, pkgs, ... }:
{
  services.xserver.displayManager.sddm = {
    enable = true;
  };
  services.xserver.desktopManager.plasma5 = {
    enable = true;
    supportDDC = true;
  };

  environment.etc."xdg/kwinrc".text = (builtins.readFile ./kwinrc);
  environment.etc."xdg/kdeglobals".text = (builtins.readFile ./kdeglobals);
}