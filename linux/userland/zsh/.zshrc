# If you come from bash you might have to change your $PATH.# export PATH=$HOME/bin:/usr/local/bin:$PATH
OS="$(uname -s)"

# Path to your oh-my-zsh installation.
export ZSH="${HOME}/.oh-my-zsh"
export QT_QPA_PLATFORMTHEME=qt5ct
export SPACESHIP_DIR_TRUNC=0
export SPACESHIP_DIR_TRUNC_REPO=false

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME # See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="spaceship"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git zsh-autosuggestions zsh-completions colored-man-pages)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# modify vi-mode plugin variable for custom mode indicator
# MODE_INDICATOR="%{$fg_bold[red]%} -- NORMAL -- %{$reset_color%}"
# RPROMPT='$(vi_mode_prompt_info)'

TRAPALRM() {
    zle reset-prompt
}
TMOUT=300

bindkey '^ ' autosuggest-accept

if [ "${OS}" != "Darwin" ]; then
    export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

    export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
    export PATH="$PATH:/Applications/Visual Studio Code - Insiders.app/Contents/Resources/app/bin"

    source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

    if [ -f "/etc/debian_version" ]; then
        source /usr/share/doc/fzf/examples/key-bindings.zsh
        alias bat=batcat
        alias fd=fdfind
    else
        source /usr/share/fzf/shell/key-bindings.zsh
    fi
fi

setopt HIST_IGNORE_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_IGNORE_ALL_DUPS
HISTSIZE=999999999

bindkey '\ek' history-search-backward
bindkey '\ej' history-search-forward

stty start undef
stty stop undef
setopt noflowcontrol

SPACESHIP_PROMPT_ORDER=(
  time          # Time stamps section
  user          # Username section
  dir           # Current directory section
  git           # Git section (git_branch + git_status)
  rust          # Rust section
  docker        # Docker section
  aws           # Amazon Web Services section
  venv          # virtualenv section
  conda         # conda virtualenv section
  pyenv         # Pyenv section
  dotnet        # .NET section
  exec_time     # Execution time
  line_sep      # Line break
  jobs          # Background jobs indicator
  exit_code     # Exit code section
  char          # Prompt character
)
export GROFF_NO_SGR=1

alias vim="nvim"
alias vi="nvim"
alias ls="exa"

if [[ -n $DISPLAY ]]; then
  x-copy-region-as-kill () {
    zle copy-region-as-kill
    print -rn -- "$CUTBUFFER" | xsel -ib
  }
  x-kill-region () {
    zle kill-region
    print -rn -- "$CUTBUFFER" | xsel -ib
  }
  x-copy-region() {
    zle vi-yank-whole-line
	print -rn -- "$CUTBUFFER" | xsel -ib
  }
  zle -N x-copy-region-as-kill
  zle -N x-kill-region
  zle -N x-copy-region
#   bindkey '\C-u' x-kill-region
  bindkey '\C-o' x-copy-region
fi

bindkey -r '\C-u'

eval "$(direnv hook zsh)"
