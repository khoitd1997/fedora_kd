#!/bin/bash

function cleanup {
    rm -f ~/.config/first_login_setup_in_progress
}
trap cleanup EXIT
currDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ${currDir}
source utils.sh
#-----------------------------------------------------------------------


if [ "${USER}" != "liveuser" ]; then
if [ ! -f ~/.config/first_login_setup_done ]; then
if [ ! -f ~/.config/first_login_setup_in_progress ]; then

touch ~/.config/first_login_setup_in_progress

# configuring konsole
mkdir -p ~/.local/share/konsole
ln -sfv ${currDir}/konsole/konsolerc ~/.config
ln -sfv ${currDir}/konsole/konsole_profile.profile ~/.local/share/konsole
ln -sfv ${currDir}/konsole/Dracula.colorscheme ~/.local/share/konsole


sleep 10 # wait till the DE has fully appeared

konsole --fullscreen --noclose -e "bash setup.sh"
fi
fi
fi