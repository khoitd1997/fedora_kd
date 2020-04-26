#!/bin/bash

sudo -E pip install fexpect -q

sudo dnf install -q -y \
    ansible \
    dnf-plugins-core

# rpmfusion-free-release-tainted \
# rpmfusion-nonfree-release-tainted