export BAT_THEME="Monokai Extended"

export FZF_DEFAULT_OPTS='--bind alt-j:down,alt-k:up'

# Setting fd as the default source for fzf
export FZF_DEFAULT_COMMAND='fd --type f'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

export TERMINAL=gnome-terminal

export LIBVIRT_DEFAULT_URI="qemu:///system"

if command -v fzf-share >/dev/null; then
    source "$(fzf-share)/key-bindings.bash"
    source "$(fzf-share)/completion.bash"
fi

if [ -x "$(command -v tool_reminders.py)" ]; then
    tool_reminders.py
fi

if [ -x "$(command -v print-client-command)" ]; then
    print-client-command
fi

if [ -x "$(command -v print-server-command)" ]; then
    print-server-command
fi

if [ -f "/var/run/reboot-required" ]; then
    echo "REBOOT IS NEEDED FOR UPDATES"
fi
