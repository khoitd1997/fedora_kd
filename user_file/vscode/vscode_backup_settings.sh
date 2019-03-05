#!/bin/bash

currDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ${currDir}

vscode_config_dir="${HOME}/.config/Code/User"
cp -vf ${vscode_config_dir}/settings.json ${currDir}/settings.json 
cp -vf ${vscode_config_dir}/keybindings.json ${currDir}/keybindings.json 

