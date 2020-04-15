#!/bin/bash

sudo dnf install -q -y \
    ansible \
    nc \
    dnf-plugins-core \
    rpmfusion-free-release \
    rpmfusion-free-release-tainted \
    rpmfusion-nonfree-release \
    rpmfusion-nonfree-release-tainted