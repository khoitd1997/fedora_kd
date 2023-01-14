{ config, pkgs, nixpkgs, home-manager, primary_user, stateVersion, ... }:
{
  home-manager.users.${primary_user} = { pkgs, ... }: {
    home = {
      stateVersion = stateVersion;
    };

    home.packages = with pkgs; [
      stress-ng
      curl
      sshpass
      wget
      fd
      tio
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

      # C++
      gcc
      (pkgs.lib.hiPrio clang)
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
      python-language-server
      pylint

      # Haskell
      # ghc
      # haskellPackages.cabal-install
      # haskellPackages.stack
      # haskell-language-server

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
      flameshot
      qtcreator
      kicad
      cura
      kdenlive
      wireshark
      firefox-wayland

      # fonts
      source-code-pro
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

      registry = {
        nixpkgs = {
          flake = nixpkgs;
        };
        home-manager = {
          flake = home-manager;
        };
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
      enableSyntaxHighlighting = true;
      initExtraBeforeCompInit = ''
        # run tmux by default unless inside vscode
        [ -z "$TMUX"  ] && [ -z "$VSCODE_INJECTION" ] && { exec tmux new-session;}

        ${builtins.readFile ./zsh/lscolors.sh}
        zstyle ':completion:*' list-colors ''${(s.:.)LS_COLORS}

        setopt nomenucomplete
        zstyle ':completion:*' menu select

        # zsh-autocomplete settings
        # zstyle ':autocomplete:*' widget-style menu-complete
        # zstyle ':autocomplete:*' min-delay 0.4
      '';
      initExtra = ''
        ${builtins.readFile ./zsh/.p10k.zsh}
        ${builtins.readFile ./zsh/colored-man-pages.plugin.zsh}
        bindkey -e

        # Up arrow:
        bindkey '\e[A' up-line-or-history
        bindkey '\eOA' up-line-or-history
        # Down arrow:
        bindkey '\e[B' down-line-or-history
        bindkey '\eOB' down-line-or-history
      '';
      shellAliases = {
        ll = "ls -l";
      };

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
          { name = "Aloxaf/fzf-tab"; }
          # { name = "marlonrichert/zsh-autocomplete"; }
          { name = "romkatv/powerlevel10k"; tags = [ as:theme depth:1 ]; }
        ];
      };
    };

    programs.bash = {
      enable = true;
      bashrcExtra = (builtins.readFile ./bash/shell_init.sh);
    };

    programs.git = {
      enable = true;
      userName = "khoitd1997";
      userEmail = "khoidinhtrinh@gmail.com";

      lfs = {
        enable = true;
      };

      difftastic = {
        enable = true;
        background = "dark";
      };
    };

    programs.vscode = {
      enable = true;
      extensions = with pkgs.vscode-extensions; [
        vscodevim.vim
        mads-hartmann.bash-ide-vscode
        oderwat.indent-rainbow
        arrterian.nix-env-selector
        yzhang.markdown-all-in-one
        redhat.vscode-yaml
        gruntfuggly.todo-tree
        dhall.dhall-lang
        dhall.vscode-dhall-lsp-server
        haskell.haskell
        justusadam.language-haskell
        ms-vscode-remote.remote-ssh
        ms-vscode.hexeditor
        ms-vscode.cpptools
        twxs.cmake
        ms-vscode.cmake-tools
        ms-python.python
        ms-python.vscode-pylance
        yzhang.markdown-all-in-one
        shd101wyy.markdown-preview-enhanced
        eamodio.gitlens
        github.vscode-pull-request-github
        donjayamanne.githistory
        ms-azuretools.vscode-docker
        mhutchie.git-graph
        jnoortheen.nix-ide
      ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "better-comments";
          publisher = "aaron-bond";
          version = "3.0.2";
          sha256 = "15w1ixvp6vn9ng6mmcmv9ch0ngx8m85i1yabxdfn6zx3ypq802c5";
        }
        {
          name = "cmake-format";
          publisher = "cheshirekow";
          version = "0.6.11";
          sha256 = "14v0wb00iy38ry9bfpzz4fjraggy4ygg5v622mfpxb7498kkrm9m";
        }
        {
          name = "tcl";
          publisher = "rashwell";
          version = "0.1.0";
          sha256 = "0zd1sb1ixz7shwfq70r5dl3b87w6pc4lc5121gcbzwixg1dkzhlk";
        }
        {
          name = "path-autocomplete";
          publisher = "ionutvmi";
          version = "1.22.1";
          sha256 = "0djfxfllxsr5lvxcvnvax25x3skyml2ybccfg9vnahs1sixymfph";
        }
        {
          name = "theme-monokai-pro-vscode";
          publisher = "monokai";
          version = "1.2.0";
          sha256 = "08z5zalc3y9j89sxav254bx5j606ym7g8dlc49yf53i0srj1bnjs";
        }
        {
          name = "intellij-idea-keybindings";
          publisher = "k--kato";
          version = "1.5.4";
          sha256 = "1y759wa4rz2n5a1cjpbj7q0n52932pv30ymhvisq9zva1cwp04yx";
        }
        {
          name = "devicetree";
          publisher = "plorefice";
          version = "0.1.1";
          sha256 = "0yfz6rgmh9j9bq7ahcjxphj74jd8rnnlg355vffdy8xfqdirxp5r";
        }
      ];
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

        # use ctrl+space for prefix instead of ctrl+b
        unbind-key C-b
        set-option -g prefix C-Space
        bind-key C-Space send-prefix
        # show PREFIX when in prefix mode
        set-option -ga status-right "#[bg=colour248,fg=colour237] #{?client_prefix,PREFIX,}"
      '';

      tmuxinator = {
        enable = true;
      };
    };

    programs.zoxide = {
      enable = true;
    };

    programs.fzf = {
      enable = true;
      defaultOptions = [ "--bind alt-j:down,alt-k:up" ];
      tmux = {
        enableShellIntegration = true;
      };
    };

    programs.bat = {
      enable = true;
      config = {
        theme = "Monokai Extended";
      };
    };

    home.sessionVariables = { EDITOR = "nvim"; };
    programs.neovim = {
      enable = true;
      # defaultEditor = true;
      viAlias = true;
      vimAlias = true;
    };

    programs.ssh = {
      enable = true;
      controlMaster = "auto";
      controlPersist = "3h";

      extraConfig = ''
        TCPKeepAlive no
        ServerAliveInterval 60
        ServerAliveCountMax 10
      '';
    };
  };
}
