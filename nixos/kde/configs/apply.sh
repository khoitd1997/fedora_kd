#!/usr/bin/env bash

set -euo pipefail
script_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# to save profile do:
# konsave -s main_profile && konsave -e main_profile -d ./nixos/kde/configs
cd ${script_dir}
konsave -i ./main_profile.knsv