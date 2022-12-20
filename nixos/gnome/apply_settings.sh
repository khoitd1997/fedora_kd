#!/usr/bin/env bash

script_dir="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
cd "${script_dir}"

dconf load / < "${script_dir}/gnome_settings.txt"