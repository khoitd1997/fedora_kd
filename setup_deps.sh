#!/bin/bash

distro=$(lsb_release -i | cut -d: -f2 | sed s/'^\t'//)

if [ "$distro" = "Ubuntu" ]; then
    sudo apt update
    sudo apt install python3-pip python-psutil build-essential zsh ansible perl -y
    sudo -E pip3 install fexpect -q
else
    sudo dnf install -q -y \
        @development-tools \
        perl-core \
        ansible \
        zsh \
        zsh-syntax-highlighting \
        dnf-plugins-core

    sudo -E pip install fexpect -q
fi
