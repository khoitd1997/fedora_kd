#!/bin/bash
set -e 

currDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ${currDir}
#----------------------------------------------------------------------

gnome-terminal&
sleep 3
dconf load /org/gnome/terminal/ < ./gnome-terminal-backup.txt