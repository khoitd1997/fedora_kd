#!/usr/bin/env bash

script_dir="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
cd "${script_dir}"

if [ "$EUID" -eq 0 ]; then 
    echo "This script cannot be run as root!"
    exit 1
fi

sudo ln -sfv "${script_dir}/configuration.nix" /etc/nixos/configuration.nix

sudo nix-channel --add https://github.com/nix-community/home-manager/archive/release-22.05.tar.gz home-manager
sudo nix-channel --add https://nixos.org/channels/nixos-unstable unstable
sudo nix-channel --update

sudo nixos-rebuild switch --upgrade

dconf load / < "${script_dir}/gnome_settings.txt"

bash "${script_dir}/../linux/userland/vscode/vscode_extension.sh"
bash "${script_dir}/../linux/userland/vscode/vscode_configure.sh"