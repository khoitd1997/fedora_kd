{ pkgs, lib, ... }:
let
  myKicad = pkgs.kicad.override { };
  kicadPluginsDir = ".local/share/kicad/${lib.versions.majorMinor myKicad.version}/scripting";
in
{
  home.file."${kicadPluginsDir}/InteractiveHtmlBom".source = pkgs.fetchFromGitHub
    {
      owner = "openscopeproject";
      repo = "InteractiveHtmlBom";
      rev = "v2.9.0";
      hash = "sha256-jUHEI0dWMFPQlXei3+0m1ruHzpG1hcRnxptNOXzXDqQ=";
    } + "/InteractiveHtmlBom";

  home.file."${kicadPluginsDir}/Board2Pdf".source = pkgs.fetchFromGitLab {
    owner = "dennevi";
    repo = "Board2Pdf";
    rev = "8c2cb8abd5559a79b0961212010d83d42bdeeca7";
    hash = "sha256-PHBrSxjcUMXPiFQSABA1tR/deinTwl3KdsLCfDR9F1o=";
  };

  home.packages = [
    myKicad
  ];
}
