#!/usr/bin/env bash

script_dir="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
cd "${script_dir}"

cp /etc/nixos/hardware-configuration.nix .

sudo nixos-rebuild switch --install-bootloader --flake .#nixos-kd
