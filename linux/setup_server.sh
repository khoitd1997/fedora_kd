#!/bin/bash

set -e

script_dir="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
cd ${script_dir}

# if this is being run locally on the server
# then use localhost otherwise use the server hostname
extra_var="variable_host=kd-server"
if [ $(hostname) = "kd-server" ]; then
    extra_var=""
fi

ansible-playbook ./userland/setup.yml \
    --ask-become-pass \
    --tags server \
    -i ${script_dir}/inventory \
    --extra-vars "${extra_var}"
