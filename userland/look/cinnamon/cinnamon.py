#!/usr/bin/env python3
# for use in setting up cinnamon

import ast
import subprocess
import json
from pathlib import Path
import os
import re

""" modify json config file """


def find_json_conf_file(rootDir: str) -> str:
    regex = re.compile('(.*json$)')
    for root, dirs, files in os.walk(rootDir):
        for file in files:
            if regex.match(file):
                return os.path.join(rootDir, file)

    return ''


home = str(Path.home())

menuConf = find_json_conf_file(os.path.join(
    home, '.cinnamon/configs/menu@cinnamon.org'))

with open(menuConf, 'r+') as f:
    data = json.load(f)

    # remove keybindings for super
    data['overlay-key']['value'] = "::"
    data['show-places']['value'] = False
    data['favbox-show']['value'] = False
    f.seek(0)
    json.dump(data, f, indent=4)
    f.truncate()

calendarConf = find_json_conf_file(os.path.join(
    home, '.cinnamon/configs/calendar@cinnamon.org'))

with open(calendarConf, 'r+') as f:
    data = json.load(f)

    # enable time custom format
    data['use-custom-format']['value'] = True
    f.seek(0)
    json.dump(data, f, indent=4)
    f.truncate()

""" remove unwanted applets """

applets = ast.literal_eval(subprocess.check_output(
    "dconf read /org/cinnamon/enabled-applets", shell=True, universal_newlines=True))

appletsToEnable = []
for i in applets:
    if not 'grouped-window-list' in i:
        appletsToEnable.append("'{0}'".format(i))

os.system(
    "dconf write /org/cinnamon/enabled-applets \"[{0}]\"".format(", ".join(appletsToEnable)))
