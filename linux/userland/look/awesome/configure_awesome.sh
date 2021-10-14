#!/bin/bash
# script to make sure awesome config files are properly installed

set -e

config_dir="~/.config/awesome"
currDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
#--------------------------------------------------------------

if [[ -L "$config_dir" && -d "$config_dir" ]]
then
    rm "$config_dir"
else
    rm -rf "$config_dir"
fi
    ln -sfv ${currDir}/data/awesome ~/.config