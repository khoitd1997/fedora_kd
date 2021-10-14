#!/bin/bash

set -e

script_dir="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
cd ${script_dir}

# extra_var="variable_host=kd-server"

ansible-playbook ./userland/setup.yml \
    --ask-become-pass \
    -i ${script_dir}/inventory \
    --tags="debug" \
    --extra-vars "${extra_var}"