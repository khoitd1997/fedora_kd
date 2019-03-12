#!/bin/bash
currDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ${currDir}
#------------------------------------------------------------------------

dconf reset -f /org/gnome/terminal/
gnome-terminal& # launch terminal to make sure a profile folder is created
sleep 2
dconf load /org/gnome/terminal/ < ${currDir}/gnome_terminal_backup.txt