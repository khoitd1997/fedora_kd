#!/bin/bash

set -e

script_dir="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
cd ${script_dir}

ansible-playbook ./userland/setup.yml \
    --ask-become-pass \
    --tags server \
    --extra-vars "variable_host=kd-server"