#!/usr/bin/env bash

set -e

script_dir="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
cd "${script_dir}"

./update_installed_exts_utils.sh > ./extensions.nix
