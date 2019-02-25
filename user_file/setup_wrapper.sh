#!/bin/bash

function cleanup {
    rm -f ~/first_login_setup_in_progress
}
trap cleanup EXIT
currDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ${currDir}
#-----------------------------------------------------------------------

if [ "${USER}" != "liveuser" ]; then
if [ ! -f ~/first_login_setup_done ]; then
if [ ! -f ~/first_login_setup_in_progress ]; then
touch ~/first_login_setup_in_progress

# configuring konsole
mkdir -p ~/.local/share/konsole
cp -v konsole/konsolerc ~/.config
cp -v konsole/konsole_profile.profile ~/.local/share/konsole

sleep 10 # wait till the DE has fully appeared
konsole --noclose -e "bash setup.sh"
fi
fi
fi