#!/usr/bin/env bash

script_dir="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
cd "${script_dir}"

sudo ln -sfv "${script_dir}/configuration.nix" /etc/nixos/configuration.nix

sudo nixos-rebuild boot --upgrade