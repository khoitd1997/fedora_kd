{ pkgs, ... }:
let
  myKicad = pkgs.kicad.override { };
in
{
  home.file.".kicad_plugins/InteractiveHtmlBom" = {
    source = pkgs.fetchFromGitHub {
      owner = "openscopeproject";
      repo = "InteractiveHtmlBom";
      rev = "v2.9.0";
      hash = "sha256-jUHEI0dWMFPQlXei3+0m1ruHzpG1hcRnxptNOXzXDqQ=";
    };
  };

  home.packages = [
    myKicad
  ];
}
