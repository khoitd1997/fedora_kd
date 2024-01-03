#!/usr/bin/env bash

set -e

script_dir="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
cd ${script_dir}

home-manager -f ./home.nix switch -b backup