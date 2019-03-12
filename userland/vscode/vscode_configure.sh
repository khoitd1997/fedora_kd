#!/bin/bash
currDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ${currDir}

#---------------------------------------------------------------------------

OS="$(uname -s)"
if [ "${OS}" == "Linux" ] ; then
vscode_config_dir="${HOME}/.config/Code/User"
else
vscode_config_dir="$APPDATA/Code/User"
fi

# copy Visual Studdio Code setting file and keybinding file
ln -sfv ${currDir}/settings.json ${vscode_config_dir}/settings.json
ln -sfv ${currDir}/keybindings.json ${vscode_config_dir}/keybindings.json
