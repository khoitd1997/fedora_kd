{ config, pkgs, ... }@args:

let
  primary_user = "ktrinh";
  stateVersion = "24.05";
  not_in_wsl = false;
in
{

  imports =
    [
      (
        import ./home-manager.nix (
          args
          // { inherit primary_user stateVersion not_in_wsl; }
        )
      )
    ];

  nix = {
    package = pkgs.nix;
  };
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.homeDirectory = "/home/${primary_user}";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
