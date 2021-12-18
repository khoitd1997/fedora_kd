#!/bin/bash

work_dir=/tmp/pwsh_install

set -e

function cleanup {
    rm -rf ${work_dir}
}
trap cleanup EXIT

rm -rf ${work_dir}
mkdir -p ${work_dir}

cd "${work_dir}"

if [ -x "$(command -v pwsh)" ]; then
    echo "Powershell is already installed, exitting"
    exit 0
fi

# got this from:
# https://docs.microsoft.com/en-us/powershell/scripting/install/install-ubuntu?view=powershell-7.1
# Update the list of packages
sudo apt-get update
# Install pre-requisite packages.
sudo apt-get install -y wget apt-transport-https software-properties-common
# Download the Microsoft repository GPG keys
wget -q https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb
# Register the Microsoft repository GPG keys
sudo dpkg -i packages-microsoft-prod.deb
# Update the list of packages after we added packages.microsoft.com
sudo apt-get update
sudo apt-get install -y powershell-lts