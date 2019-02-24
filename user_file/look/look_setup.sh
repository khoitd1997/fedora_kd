#!/bin/bash
# look setup for rpm based system

currDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ${currDir}
source ../utils.sh

set -e 
set -o pipefail
set -o nounset

#------------------------------------------------------------------------
dconf write /org/cinnamon/desktop/background/picture-uri "'file:///usr/share/user_file/resource/TCP118v1_by_Tiziano_Consonni.jpg'"

# theme
dconf write /org/cinnamon/desktop/interface/gtk-theme "'Arc-Dark-solid'"
dconf write /org/cinnamon/desktop/wm/preferences/theme "'Arc-Dark'"
dconf write /org/cinnamon/theme/name "'Arc-Dark-solid'"
dconf write /org/cinnamon/settings-daemon/plugins/power/sleep-display-ac "10800"
dconf write /org/cinnamon/settings-daemon/plugins/power/idle-dim-battery "false"
dconf write /org/cinnamon/cinnamon-session/quit-delay-toggle "true"
dconf write /org/cinnamon/enable-indicators "true"
dconf write /org/cinnamon/sounds/login-enabled "false"
dconf write /org/cinnamon/cinnamon-session/quit-time-delay "20"
dconf write /org/cinnamon/desktop/notifications/remove-old "true"

# panels
dconf write /org/cinnamon/panels-enabled "['1:0:top']"
dconf write /org/cinnamon/panels-height "['1:25']"

# effects 
dconf write /org/cinnamon/desktop-effects "false"
dconf write /org/cinnamon/desktop/interface/gtk-overlay-scrollbars "false"
dconf write /org/cinnamon/startup-animation "false"
dconf write /org/cinnamon/enable-vfade "false"

# sound
dconf write /org/cinnamon/sounds/switch-enabled "false"
dconf write /org/cinnamon/sounds/map-enabled "false"
dconf write /org/cinnamon/sounds/close-enabled "false"
dconf write /org/cinnamon/sounds/minimize-enabled "false"
dconf write /org/cinnamon/sounds/maximize-enabled "false"
dconf write /org/cinnamon/sounds/unmaximize-enabled "false"
dconf write /org/cinnamon/sounds/tile-enabled "false"
dconf write /org/cinnamon/sounds/notification-enabled "false"

dconf write /org/cinnamon/desktop/interface/text-scaling-factor "1.1000000000000003"
dconf write /org/cinnamon/alttab-switcher-style "'icons+preview'"
dconf write /org/cinnamon/panels-autohide "['1:false']"
dconf write /org/cinnamon/settings-daemon/peripherals/touchscreen/orientation-lock "true"
dconf write /org/cinnamon/settings-daemon/plugins/power/sleep-display-ac "0"
dconf write /org/gnome/libgnomekbd/keyboard/options "['caps\tcaps:escape']"
dconf write /org/cinnamon/desktop/keybindings/wm/show-desktop "['<Primary><Alt>d']"

dconf write /org/nemo/desktop/computer-icon-visible "false"
dconf write /org/nemo/desktop/home-icon-visible "false"
dconf write /org/nemo/desktop/trash-icon-visible "false"
dconf write /org/cinnamon/desktop/session/idle-delay "uint32 0"

# nemo
dconf write /org/nemo/preferences/never-queue-file-ops "true"
dconf write /org/nemo/preferences/show-open-in-terminal-toolbar "true"
dconf write /org/nemo/preferences/show-new-folder-icon-toolbar "true"

# customize gnome terminal
dconf reset -f /org/gnome/terminal/
gnome-terminal& # launch terminal to make sure a profile folder is created
sleep 2
dconf load /org/gnome/terminal/ < ${currDir}/gnome_terminal_backup.txt
# pkill gnome-terminal

python3 ${currDir}/cinnamon.py
