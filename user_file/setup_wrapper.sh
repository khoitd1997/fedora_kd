#!/bin/bash

function cleanup {
    rm -f ~/first_login_setup_in_progress
}
trap cleanup EXIT
currDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ${currDir}
#-----------------------------------------------------------------------

if [ ! -f ~/first_login_setup_done ]; then
if [ ! -f ~/first_login_setup_in_progress ]; then
cp -v konsole/konsolerc ~/.config
cp -v konsole/konsole_profile.profile ~/.local/share/konsole

touch ~/first_login_setup_in_progress
# sleep 20 # wait till the DE has fully appeared
konsole --noclose -e "bash setup.sh"
fi
fi
