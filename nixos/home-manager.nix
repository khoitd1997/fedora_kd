{ config, pkgs, primary_user, stateVersion, lib, not_in_wsl ? true, ... }:
let
  unstable = import <unstable> {
    config.allowUnfree = true;
  };

  # sometimes it's nice to be able to launch simple bash
  # terminal in case zsh messes up
  bashTerminal = pkgs.makeDesktopItem {
    name = "bash terminal";
    exec = "alacritty -e bash";
    comment = "Launch a terminal with bash as shell";
    desktopName = "bash terminal";
    type = "Application";
  };

  # most extensions can just be installed using extensionsFromVscodeMarketplace
  # except for a special few, check pkgs/applications/editors/vscode/extensions for list
  # of special ones
  specialVscodeExtensions = [
    rec {
      name = "remote-ssh";
      publisher = "ms-vscode-remote";
      ext = unstable.vscode-extensions.${publisher}.${name};
    }
    rec {
      name = "vscode-pull-request-github";
      publisher = "GitHub";
      ext = unstable.vscode-extensions.github.${name};
    }
    rec {
      name = "gitlens";
      publisher = "eamodio";
      ext = unstable.vscode-extensions.${publisher}.${name};
    }
    rec {
      name = "vscode-pylance";
      publisher = "ms-python";
      ext = unstable.vscode-extensions.${publisher}.${name};
    }
    rec {
      name = "rust-analyzer";
      publisher = "rust-lang";
      ext = unstable.vscode-extensions.${publisher}.${name};
    }
  ] ++ lib.optionals pkgs.stdenv.hostPlatform.isx86_64 [
    rec {
      name = "python";
      publisher = "ms-python";
      ext = unstable.vscode-extensions.${publisher}.${name};
    }
    rec {
      name = "cpptools";
      publisher = "ms-vscode";
      ext = unstable.vscode-extensions.${publisher}.${name};
    }
  ];
  normalVscodeExtensions = builtins.filter
    (
      x: builtins.all
        (specialExt: !((x.name == specialExt.name) && (x.publisher == specialExt.publisher)))
        specialVscodeExtensions
    )
    (import ./vscode/extensions.nix).extensions;
in
{
    imports = [
      ./zellij/zellij.nix
      ./nvim/nvim.nix
    ];

    fonts.fontconfig.enable = true;

    home = {
      username = primary_user;
      inherit stateVersion;
      shellAliases = {
        code = "env -u ZELLIJ -u ZELLIJ_SESSION_NAME code";
      };
    };

    home.packages = with pkgs; [
      yaml-language-server
      vscode-langservers-extracted
      neovim-qt
      stress-ng
      curl
      sshpass
      wget
      fd
      tio
      picocom
      ripgrep
      tldr
      tig
      hexyl
      pylint
      openocd
      strace
      lshw
      moreutils
      jq
      doxygen
      nettools
      neofetch
      hyperfine
      tree
      gawk
      ansible
      file
      entr
      duf
      du-dust
      xclip
      nixpkgs-fmt
      cabal2nix
      rnix-lsp
      nixos-option
      sshfs
      ncdu
      nmap
      pciutils
      usbutils
      bind
      tcpdump
      traceroute
      libarchive
      unzip
      procs
      distrobox
      git-extras
      lazygit
      procs
      stgit
      jless
      nix-diff
      rustup
      shellcheck
      statix
      nodePackages.bash-language-server
      nodePackages.pyright
      helix

      # C++
      gcc_latest
      (pkgs.lib.hiPrio llvmPackages_latest.clang)
      clang-tools
      bloaty
      cppcheck
      cpplint
      cmake
      cmake-format
      ninja
      clang-analyzer
      gcc-arm-embedded
      perf-tools
      lttng-tools

      # Python
      python3Full
      black
      pylint

      # Haskell
      ghc
      haskellPackages.cabal-install
      haskell-language-server

      # virtualization
      qemu_full
      virt-manager

      # dhall
      dhall
      dhall-lsp-server

      # latex
      texlive.combined.scheme-full

      # GUI apps
      gparted
      qtcreator
      kicad
      cura
      kdenlive
      wireshark
      firefox-wayland

      # fonts
      source-code-pro
      nerdfonts

      bashTerminal
    ];

    # TODO: This might be necessary once we are on Ubuntu
    # services.home-manager.autoUpgrade = {
    #   enable = true;
    #   frequency = "weekly";
    # };

    services.flameshot = {
      enable = true;
    };

    nixpkgs.config = {
      allowUnfree = true;
    };

    nix = {
      enable = true;
      settings = {
        experimental-features = [ "nix-command" "flakes" ];
      };
    };

    programs.kitty = {
      enable = true;
    };
    programs.alacritty = {
      enable = true;
      settings = {
        font.normal = {
          family = "Source Code Pro";
        };
      };
    };

    programs.zsh = {
      enable = true;
      # enableAutosuggestions = true;
      syntaxHighlighting.enable = true;
      initExtraBeforeCompInit = ''
        ${builtins.readFile ./zsh/lscolors.sh}
        zstyle ':completion:*' list-colors ''${(s.:.)LS_COLORS}

        setopt nomenucomplete
        zstyle ':completion:*' menu select

        # zsh-autocomplete settings
        # zstyle ':autocomplete:*' widget-style menu-complete
        # zstyle ':autocomplete:*' min-delay 0.4

        # ctrl+x ctrl+e to edit command line in vim
        autoload -z edit-command-line
        zle -N edit-command-line
        bindkey "^X^E" edit-command-line
      '';
      initExtra = ''
        ${builtins.readFile ./zsh/.p10k.zsh}
        ${builtins.readFile ./zsh/colored-man-pages.plugin.zsh}
        export HISTSIZE=1000000000
        export SAVEHIST=$HISTSIZE
        export XILINXD_LICENSE_FILE=2100@10.32.4.123
        setopt HIST_IGNORE_ALL_DUPS

        bindkey -e

        bindkey "^[[1;5C" forward-word
        bindkey "^[[1;5D" backward-word
        bindkey "\e[3~" delete-char

        # Up arrow:
        bindkey '\e[A' up-line-or-history
        bindkey '\eOA' up-line-or-history
        bindkey '^[k' up-line-or-history
        # Down arrow:
        bindkey '\e[B' down-line-or-history
        bindkey '\eOB' down-line-or-history
        bindkey '^[j' down-line-or-history

        # fix this issue: https://github.com/jeffreytse/zsh-vi-mode/issues/24
        zvm_after_init() {
          . ${pkgs.fzf}/share/fzf/completion.zsh
          . ${pkgs.fzf}/share/fzf/key-bindings.zsh
        }
      '';

      # only do completion init once every day
      completionInit = ''
        autoload -Uz compinit
        for dump in ~/.zcompdump(N.mh+24); do
          compinit
        done
        compinit -C
      '';

      zplug = {
        enable = true;
        plugins = [
          { name = "zsh-users/zsh-completions"; }
          { name = "jeffreytse/zsh-vi-mode"; }
          { name = "Aloxaf/fzf-tab"; }
          { name = "romkatv/powerlevel10k"; tags = [ "as:theme" "depth:1" ]; }
        ];
      };
    };

    programs.bash = {
      enable = true;
      bashrcExtra = builtins.readFile ./bash/shell_init.sh;
      historySize = 10000000;
      historyFileSize = 10000000;
      historyControl = [ "erasedups" "ignoredups" ];
    };

    programs.git = {
      enable = true;
      userName = "khoitd1997";
      userEmail = "khoidinhtrinh@gmail.com";
      extraConfig = {
        pull.ff = "only";
        commit.verbose = true;
        advice.skippedCherryPicks = false;
        branch.sort = "-committerdate";
        column.ui = "auto";

        fetch = {
          prune = true;
          output = "compact";
          parallel = 0;
        };

        push = {
          followTags = true;
          autoSetupRemote = true;
        };
        rebase.stat = true;
        merge.conflictStyle = "diff3";

        diff = {
          algorithm = "histogram";
          mnemonicPrefix = true;
          renames = true;
          submodule = "log";
        };

        mergetool = {
          # Clean up backup files created by merge tools on tool exit
          keepBackup = false;
          # Clean up temp files created by merge tools on tool exit
          keepTemporaries = false;
          # Put the temp files in a dedicated dir anyway
          writeToTemp = true;
          # Auto-accept file prompts when launching merge tools
          prompt = false;
        };
        status = {
          # Display submodule rev change summaries in status
          submoduleSummary = true;
          # Recursively traverse untracked directories to display all contents
          showUntrackedFiles = "all";
        };
      };

      lfs = {
        enable = true;
      };
      delta = {
        enable = true;
      };
    };

    programs.vscode = {
      enable = not_in_wsl;
      package = unstable.vscode;
      extensions =
        (builtins.map (x: x.ext) specialVscodeExtensions) ++
        unstable.vscode-utils.extensionsFromVscodeMarketplace normalVscodeExtensions;
    };

    programs.htop = {
      enable = true;
      settings = {
        hide_kernel_threads = 1;
        hide_userland_threads = 0;
        shadow_other_users = 0;
        show_thread_names = 1;
        show_program_path = 1;
        highlight_base_name = 1;
        highlight_deleted_exe = 1;
        highlight_megabytes = 1;
        highlight_threads = 1;
        highlight_changes = 0;
        highlight_changes_delay_secs = 5;
        find_comm_in_cmdline = 1;
        strip_exe_from_cmdline = 1;
        show_merged_command = 0;
        header_margin = 1;
        screen_tabs = 1;
        detailed_cpu_time = 0;
        cpu_count_from_one = 0;
        show_cpu_usage = 1;
        show_cpu_frequency = 0;
        show_cpu_temperature = 0;
        degree_fahrenheit = 0;
        update_process_names = 0;
        account_guest_in_cpu_meter = 0;
        color_scheme = 0;
        enable_mouse = 1;
        delay = 15;
        tree_view = 1;
      };
    };

    programs.broot = {
      enable = true;
    };

    programs.tmux = {
      enable = true;
      sensibleOnTop = true;
      baseIndex = 1;
      clock24 = true;
      terminal = "xterm-256color";
      keyMode = "vi";

      plugins = with pkgs.tmuxPlugins; [
        better-mouse-mode
        tmux-thumbs
        gruvbox
        pain-control
      ];

      extraConfig = ''
        # clipboard
        set-option -s set-clipboard off

        # mouse stuffs
        set -g mouse on
        bind-key -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-pipe-and-cancel "xclip -selection clipboard -i"

        # tmux thumb config
        set -g @thumbs-command 'echo -n {} | xclip -in -selection clipboard'
        # set -g @thumbs-osc52 1
        set -g @thumbs-unique enabled
        set -g @thumbs-reverse enabled
        set -g @thumbs-fg-color magenta
        # match all things separated by whitespace
        set -g @thumbs-regexp-1 '[\S]+'
        # to make tmux thumb perform better
        set -g visual-activity off
        set -g visual-bell off
        set -g visual-silence on

        # use ctrl+space for prefix instead of ctrl+b
        unbind-key C-b
        set-option -g prefix C-Space
        bind-key C-Space send-prefix
        # show PREFIX when in prefix mode
        set-option -ga status-right "#[bg=colour248,fg=colour237] #{?client_prefix,PREFIX,}"

        set -g pane-active-border-style fg=colour208,bg=default

        # reduce escape time so that things like vim
        # is more responsive
        set -g focus-event on
      '';
    };

    programs.zoxide = {
      enable = true;
    };

    programs.fzf = {
      enable = true;
      defaultOptions = [ "--bind alt-j:down,alt-k:up" ];
    };

    programs.bat = {
      enable = true;
      config = {
        theme = "Monokai Extended";
      };
    };

    home.sessionVariables = {
      NIX_SHELL_PRESERVE_PROMPT = 1;
      EDITOR = "nvim";
      FZF_CTRL_T_OPTS = "--preview='bat --color \"always\" -r :500 {}'";
    };

    programs.ssh = {
      enable = true;
      controlMaster = "auto";
      controlPersist = "3h";

      extraConfig = ''
        TCPKeepAlive yes
        ServerAliveInterval 60
        ServerAliveCountMax 10
      '';
    };
}
