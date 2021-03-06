source /usr/share/doc/fzf/examples/key-bindings.fish
fzf_key_bindings

bind \cd accept-autosuggestion
bind \ej down-or-search
bind \ek history-token-search-backward
bind \ek up-or-search
bind \ej history-token-search-forward

alias ls='exa'
alias bat='batcat'
alias fd='fdfind'
alias vim='nvim'
alias vi='nvim'

set fish_greeting
set -U fish_prompt_pwd_dir_length 0

# bass source /tools/Xilinx/Vivado/2020.1/settings64.sh
