{ config, pkgs, lib, ... }:
{
  programs.rofi = {
    enable = true;
    cycle = true;
    plugins = [
      pkgs.rofi-calc
      pkgs.rofi-file-browser
    ];
    theme = "gruvbox-dark";

    extraConfig = {
      # file-browser-extended not in modi since it slows down launch time
      modi = "window,run,drun,combi,ssh";
      show-icons = true;
      steal-focus = true;
      sort = true;
      combi-modi = "drun,run,ssh";
      matching = "fuzzy";
      kb-row-up = "Alt+k,Up,Control+p";
      kb-row-down = "Alt+j,Down,Control+n";

      # continuous scroll
      scroll-method = 1;

      # by default have to do shift+enter to run selected app
      # so configure it to just be enter
      kb-accept-entry = "";
      kb-accept-alt = "Return";
    };
  };
  home.file."${config.xdg.configHome}/rofi/file-browser".text = ''
    depth 0
    dir

    only-files
  '';

  home.file."${config.xdg.configHome}/greenclip.toml".text = ''
    [greenclip]
      history_file = "${config.home.homeDirectory}/.cache/greenclip.history"
      max_history_length = 50
      max_selection_size_bytes = 0
      trim_space_from_selection = true
      use_primary_selection_as_input = false
      blacklisted_applications = []
      enable_image_support = true
      image_cache_directory = "/tmp/greenclip"
      static_history = []
  '';
  systemd.user.services.greenclip = {
    Unit = {
      Description = "Greenclip clipboard management daemon";
      After = [ "graphical-session.target" ];
    };

    Service = {
      ExecStart = "${pkgs.haskellPackages.greenclip}/bin/greenclip daemon";
    };

    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}
