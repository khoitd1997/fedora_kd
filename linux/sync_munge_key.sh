#!/bin/bash

set -e

script_dir="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
cd "${script_dir}"

if [ $(hostname) != "kd-server" ]; then
    echo "This can only be run from slurm controller, exitting"
    exit 1
fi

function cleanup {
    rm -rfv "${munge_key_path}"
}
trap cleanup EXIT

# copy the key to a location readable by runner of the
# script, make very sure that no one else can read it
munge_key_path="/tmp/munge.key"
sudo -s <<EOF
    cp /etc/munge/munge.key ${munge_key_path}
    chmod u=r,g=,o= ${munge_key_path}
    chown ${USER}: ${munge_key_path}
EOF

ansible-playbook ./userland/setup.yml \
    --ask-become-pass \
    --tags munge-key \
    -i "${script_dir}/inventory" \
    --extra-vars "munge_key_path=${munge_key_path}" \
    --extra-vars "variable_host=client_group"
