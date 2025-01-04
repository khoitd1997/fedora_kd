#!/usr/bin/env bash

set -e

script_dir="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
cd "${script_dir}"

nix flake lock --update-input nixpkgs --update-input nixpkgs-unstable --update-input home-manager
