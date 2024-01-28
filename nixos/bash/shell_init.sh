export TERMINAL=kitty

export LIBVIRT_DEFAULT_URI="qemu:///system"

export PROMPT="\[\e[36m\]\w\[\e[m\] "

if [[ -n "$IN_NIX_SHELL" ]]; then
    export PS1="\[\e[33m\](nix-shell)\[\e[m\] ${PROMPT}\n> "
else
    export PS1="${PROMPT}\n> "
fi
