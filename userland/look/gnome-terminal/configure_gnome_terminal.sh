#!/bin/bash
currDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
#----------------------------------------------------------------------

gnome-terminal&
sleep 3
dconf load /org/gnome/terminal/ < ${currDir}/gnome-terminal-backup.txt