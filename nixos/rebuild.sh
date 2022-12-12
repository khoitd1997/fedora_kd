#!/usr/bin/env bash

script_dir="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
cd "${script_dir}"

sudo nixos-rebuild boot --install-bootloader --flake '.#nixos-kd'
