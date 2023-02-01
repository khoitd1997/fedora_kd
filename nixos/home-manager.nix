{ config, pkgs, primary_user, stateVersion, ... }:
{
  imports = [
    <home-manager/nixos>
  ];

  home-manager.users.${primary_user} = { pkgs, ... }: {
    home = {
      stateVersion = stateVersion;
      shellAliases = {
        code = "env -u TMUX_PANE -u TMUX -u TMUX_TMPDIR code";
      };
    };

    home.packages = with pkgs; [
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
      python-language-server
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
        # run tmux by default
        [ -z "$TMUX_PANE"  ] && { exec tmux new-session;}

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
        export HISTSIZE=1000000000
        export SAVEHIST=$HISTSIZE
        setopt share_history
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
        # ms-python.python
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
        set -g @thumbs-osc52 1

        # use ctrl+space for prefix instead of ctrl+b
        unbind-key C-b
        set-option -g prefix C-Space
        bind-key C-Space send-prefix
        # show PREFIX when in prefix mode
        set-option -ga status-right "#[bg=colour248,fg=colour237] #{?client_prefix,PREFIX,}"

        set -g pane-active-border-style fg=colour208,bg=default

        # reduce escape time so that things like vim
        # is more responsive
        set -sg escape-time 0
        set -g focus-event on
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
    programs.neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;

      coc = {
        enable = true;
        settings = {
          "colors.enable" = true;
          "codeLens.enable" = true;
          "coc.preferences.enableLinkedEditing" = true;
          "diagnostic.floatConfig" = {
            "rounded" = true;
            "border" = true;
          };
          "diagnostic.format" = "%message [%source]";
          "diagnostic.virtualText" = true;
          "diagnostic.checkCurrentLine" = true;
          "diagnostic.separateRelatedInformationAsDiagnostics" = true;
        };
      };

      extraConfig = ''
        set timeoutlen=1000
        set ttimeoutlen=50

        filetype plugin on

        set noswapfile
        set number relativenumber
        set nu rnu

        "Ctrl+s for saving
        noremap <silent> <C-S> :update<CR>
        vnoremap <silent> <C-S> <C-C>:update<CR>
        inoremap <silent> <C-S> <C-O>:update<CR>

        "bind ctrl+z to undo
        nnoremap <c-z> :undo <CR>
        vnoremap <c-z> :undo <CR>
        inoremap <c-z> <esc>:undo <CR>

        "coc alt-j and alt-k to navigate completions
        execute "map \ej <M-j>"
        inoremap <expr> <M-j> coc#pum#visible() ? coc#pum#next(1) : "<M-j>"
        execute "map \ek <M-k>"
        inoremap <expr> <M-k> coc#pum#visible() ? coc#pum#prev(1) : "<M-k>"

        "coc tab and enter to select the completions
        inoremap <expr> <Tab> coc#pum#visible() ? coc#_select_confirm() : "<Tab>"
        inoremap <expr> <cr> coc#pum#visible() ? coc#_select_confirm() : "<cr>"
      '';

      plugins = with pkgs.vimPlugins; [
        coc-json
        coc-pyright
        coc-sh
        coc-yaml

        vim-surround
        vim-nix

        {
          plugin = fzf-vim;
          config = ''
            "ctrl+shift+n to search for files
            nnoremap <silent> <C-N> :Files<CR>
            vnoremap <silent> <C-N> :Files<CR>
          '';
        }
        {
          plugin = gruvbox;
          config = ''
            colorscheme gruvbox
          '';
        }
        {
          plugin = nerdcommenter;
          config = ''
            "ctrl + / for commenting
            nmap <C-_>   <Plug>NERDCommenterToggle
            vmap <C-_>   <Plug>NERDCommenterToggle<CR>gv

            let g:NERDCreateDefaultMappings = 0
          '';
        }
        {
          plugin = vim-gitgutter;
          config = ''
            set updatetime=100
            set signcolumn=yes

            highlight GitGutterAdd    ctermbg=191 ctermfg=2
            highlight GitGutterChange ctermbg=214 ctermfg=3
            highlight GitGutterDelete ctermbg=160 ctermfg=1
            highlight GitGutterChangeDelete ctermbg=160 ctermfg=1
          '';
        }
      ];
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
  };
}
