{ config, pkgs, home-manager, ... }:
{
  home-manager.users.kd = { pkgs, ... }: {
    home = {
      stateVersion = "22.11";
    };

    nixpkgs.config = {
      allowUnfree = true;
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
      ];
    };

    programs.zsh = {
      enable = true;
      enableAutosuggestions = true;
      enableSyntaxHighlighting = true;
      initExtra = ''
        if [ -n "''${commands[fzf-share]}" ]; then
          source "$(fzf-share)/key-bindings.zsh"
          source "$(fzf-share)/completion.zsh"
        fi

        ${builtins.readFile ./zsh/.p10k.zsh}
        bindkey -e
        setopt nomenucomplete
      '';
      shellAliases = {
        ll = "ls -l";
      };
      zplug = {
        enable = true;
        plugins = [
          { name = "romkatv/powerlevel10k"; tags = [ as:theme depth:1 ]; }
        ];
      };
    };
  };
}
