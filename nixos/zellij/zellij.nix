{ config, pkgs, ... }:
let
  unstable = import <unstable> {
    config.allowUnfree = true;
  };
in
{
  home.packages = [
    unstable.zellij
  ];
    home = {
      shellAliases = {
        zellij-tab-sysmon = "zellij action new-tab --layout system_monitor --name Sysmon";
      };
    };
  xdg.configFile."zellij/config.kdl" = {
    source = ./config.kdl;
  };
  xdg.configFile."zellij/layouts/system_monitor.kdl" = {
    source = ./system_monitor.kdl;
  };
}