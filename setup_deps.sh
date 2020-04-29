#!/bin/bash

sudo -E pip install fexpect -q

# development tools and perl in case needing to build something from source
sudo dnf install -q -y \
    @development-tools \
    perl-core \
    ansible \
    zsh \
    zsh-syntax-highlighting \
    dnf-plugins-core

# rpmfusion-free-release-tainted \
# rpmfusion-nonfree-release-tainted