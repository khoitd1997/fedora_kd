{ pkgs, lib, ... }:
{
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting = {
      enable = true;
      highlighters = [ "main" "brackets" ];
    };
    shellAliases = {
      "ls" = "${lib.getExe pkgs.lsd}";
    };
    initExtraBeforeCompInit = ''
      # ctrl space to accept auto suggestion
      bindkey '^ ' autosuggest-accept

      ${builtins.readFile ./lscolors.sh}
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
      ${builtins.readFile ./.p10k.zsh}
      ${builtins.readFile ./colored-man-pages.plugin.zsh}
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
      
      # zoxide stuffs
      export _ZO_ECHO=1
      export _ZO_RESOLVE_SYMLINKS=1
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
        { name = "hlissner/zsh-autopair"; }
        { name = "jeffreytse/zsh-vi-mode"; }
        { name = "Aloxaf/fzf-tab"; }
        { name = "romkatv/powerlevel10k"; tags = [ "as:theme" "depth:1" ]; }
      ];
    };

    history = {
      expireDuplicatesFirst = true;
    };
    historySubstringSearch.enable = true;
  };
}
