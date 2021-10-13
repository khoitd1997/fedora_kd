#!/bin/bash

set -e

currDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
#----------------------------------------------------------------------------------------------------------

git submodule update --init --remote

# vscode stuffs
bash ../fedora_kd/userland/vscode/vscode_extension.sh
bash ../fedora_kd/userland/vscode/vscode_configure.sh
# replace fonts for windows
# sed -ie 's:source code pro:Consolas:g' $APPDATA/Code/User/settings.json