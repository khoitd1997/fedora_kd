#!/usr/bin/env bash

set -e

script_dir="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
cd "${script_dir}"

release_version="23.11"

sudo nix-channel --add https://nixos.org/channels/"nixos-${release_version}" nixos
sudo nix-channel --add https://github.com/nix-community/home-manager/archive/release-${release_version}.tar.gz home-manager
sudo nix-channel --add https://nixos.org/channels/nixos-unstable unstable

sudo nix-channel --update
./rebuild.sh
