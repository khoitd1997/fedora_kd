#!/bin/bash

set -e

currDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd /tmp

if [ -f ~/.fonts/SourceCodePro-Regular.otf ]; then
    echo "Source code pro is already installed, exitting"
    exit 0
fi

wget https://github.com/adobe-fonts/source-code-pro/archive/2.030R-ro/1.050R-it.zip --output-document source-code-pro.zip
mkdir -p ~/.fonts

unzip source-code-pro.zip
cp source-code-pro-*-it/OTF/*.otf ~/.fonts/
rm -rf source-code-pro* 
rm -f source-code-pro.zip
cd ~/
fc-cache -f -v