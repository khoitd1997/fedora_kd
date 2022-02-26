#!/bin/bash

set -e

distro=$(lsb_release -i | cut -d: -f2 | sed s/'^\t'//)

if [ "$distro" = "Ubuntu" ]; then
    sudo apt update
    sudo apt install python3-pip curl python3-psutil build-essential zsh ansible perl -y
    sudo -E pip3 install fexpect -q
    sudo ubuntu-drivers install
else
    sudo dnf install -q -y \
        @development-tools \
        perl-core \
        ansible \
        curl \
        zsh \
        zsh-syntax-highlighting \
        dnf-plugins-core

    sudo -E pip install fexpect -q
fi
