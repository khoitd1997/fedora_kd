#!/bin/bash

set -e

currDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd /tmp

wget https://github.com/adobe-fonts/source-code-pro/archive/2.030R-ro/1.050R-it.zip
mkdir -p ~/.fonts

unzip 1.050R-it.zip 
cp source-code-pro-*-it/OTF/*.otf ~/.fonts/
rm -rf source-code-pro* 
rm 1.050R-it.zip 
cd ~/
fc-cache -f -v