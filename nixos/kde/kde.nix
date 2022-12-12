{ config, pkgs, ... }:
{
  services.xserver.displayManager.sddm = {
    enable = true;
  };
  services.xserver.desktopManager.plasma5 = {
    enable = true;
    supportDDC = true;
  };

  environment.etc = {
    "xdg/kwinrc".text = (builtins.readFile ./conf/kwinrc);
    "xdg/kdeglobals".text = (builtins.readFile ./conf/kdeglobals);
    "xdg/kcminputrc".text = (builtins.readFile ./conf/kcminputrc);
    "xdg/kscreenlockerrc".text = (builtins.readFile ./conf/kscreenlockerrc);
    "xdg/kaccessrc".text = (builtins.readFile ./conf/kaccessrc);
    "xdg/kxkbrc".text = (builtins.readFile ./conf/kxkbrc);
  };
}