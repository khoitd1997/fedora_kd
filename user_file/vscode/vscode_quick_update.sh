#!/bin/bash

currDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ${currDir}

vscode_config_dir="${HOME}/.config/Code/User"
cp -vf ${currDir}/settings.json ${vscode_config_dir}/
cp -vf ${currDir}/keybindings.json ${vscode_config_dir}/

