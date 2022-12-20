#!/usr/bin/env bash

script_dir="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
cd "${script_dir}"

if [ "$EUID" -eq 0 ]; then 
    echo "This script cannot be run as root!"
    exit 1
fi

# generate hardware-configuration.nix
rm -f ./hardware-configuration.nix
sudo nixos-generate-config --dir .

./rebuild.sh

bash "${script_dir}/../linux/userland/vscode/vscode_extension.sh"
bash "${script_dir}/../linux/userland/vscode/vscode_configure.sh"