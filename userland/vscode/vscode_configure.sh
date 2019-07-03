#!/bin/bash
currDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ${currDir}

#---------------------------------------------------------------------------

OS="$(uname -s)"
if [ "${OS}" == "Linux" ] ; then
    vscode_config_dir="${HOME}/.config/Code/User"
    vscode_insider_config_dir="${HOME}/.config/Code - Insiders/User"
else
    vscode_config_dir="$APPDATA/Code/User"
    vscode_insider_config_dir="$APPDATA/Code - Insiders/User"
fi

code&
sleep 5

# copy Visual Studdio Code setting file and keybinding file
ln -sfv ${currDir}/settings.json ${vscode_config_dir}/settings.json
ln -sfv ${currDir}/keybindings.json ${vscode_config_dir}/keybindings.json

if [ -x "$(command -v code-insiders)" ]; then
    code-insiders&
    sleep 5
    ln -sfv ${currDir}/settings.json "${vscode_insider_config_dir}/settings.json"
    ln -sfv ${currDir}/keybindings.json "${vscode_insider_config_dir}/keybindings.json"
fi
