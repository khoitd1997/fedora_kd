{ pkgs, lib, config, ... }:
let
  myKicad = pkgs.kicad.override {
    addons = with pkgs.kicadAddons; [ kikit kikit-library ];
  };
  kicadVersion = lib.versions.majorMinor myKicad.version;
  kicadPluginsDir = ".local/share/kicad/${kicadVersion}/scripting";
  kicadThemeDir = ".local/share/kicad/${kicadVersion}/3rdparty/colors";

  kicadTheme = pkgs.fetchFromGitHub {
    owner = "pointhi";
    repo = "kicad-color-schemes";
    rev = "68ea0402f334bdbae175f6ca924743640c07183d";
    hash = "sha256-PYgFOyK5MyDE1vTkz5jGnPWAz0pwo6Khu91ANgJ2OO4=";
  };

  # NOTE: For a list of possible themes, check the folder names in https://github.com/pointhi/kicad-color-schemes/tree/master
  kicadSchematicTheme = "wdark";
  kicadPcbNewTheme = "behave-dark";
  kicadSymbolEditorTheme = "nord";
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

  home.file."${kicadThemeDir}/${kicadSchematicTheme}/${kicadSchematicTheme}.json".source = kicadTheme + "/${kicadSchematicTheme}/${kicadSchematicTheme}.json";
  home.file."${kicadThemeDir}/${kicadPcbNewTheme}/${kicadPcbNewTheme}.json".source = kicadTheme + "/${kicadPcbNewTheme}/${kicadPcbNewTheme}.json";
  home.file."${kicadThemeDir}/${kicadSymbolEditorTheme}/${kicadSymbolEditorTheme}.json".source = kicadTheme + "/${kicadSymbolEditorTheme}/${kicadSymbolEditorTheme}.json";

  home.activation.kicadConfig = lib.getExe (pkgs.writeShellApplication {
    name = "kicad-config";
    runtimeInputs = with pkgs; [ jq moreutils ];
    text = ''
      # schematic theme
      eeschema_conf="${config.xdg.configHome}/kicad/${kicadVersion}/eeschema.json"
      jq '.appearance.color_theme = "${config.home.homeDirectory}/${kicadThemeDir}/${kicadSchematicTheme}/${kicadSchematicTheme}.json"' $eeschema_conf | sponge $eeschema_conf

      # pcb layout theme
      pcbnew_conf="${config.xdg.configHome}/kicad/${kicadVersion}/pcbnew.json"
      jq '.appearance.color_theme = "${config.home.homeDirectory}/${kicadThemeDir}/${kicadPcbNewTheme}/${kicadPcbNewTheme}.json"' $pcbnew_conf | sponge $pcbnew_conf

      # symbol editor theme
      symbol_editor_conf="${config.xdg.configHome}/kicad/${kicadVersion}/symbol_editor.json"
      jq '.appearance.color_theme = "${config.home.homeDirectory}/${kicadThemeDir}/${kicadSymbolEditorTheme}/${kicadSymbolEditorTheme}.json"' $symbol_editor_conf | sponge $symbol_editor_conf
    '';
  });

  home.packages = [
    myKicad
  ];
}
