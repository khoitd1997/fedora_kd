#!/usr/bin/env python3
# for use in setting up cinnamon

import json
from pathlib import Path
import os


home = str(Path.home())

menuConf = os.path.join(
    home, '.cinnamon/configs/menu@cinnamon.org/1.json')

with open(menuConf, 'r+') as f:
    data = json.load(f)

    # remove keybindings for super
    data['overlay-key']['value'] = "::"
    data['show-places']['value'] = False
    data['favbox-show']['value'] = False
    f.seek(0)
    json.dump(data, f, indent=4)
    f.truncate()

calendarConf = os.path.join(
    home, '.cinnamon/configs/calendar@cinnamon.org/12.json')

with open(calendarConf, 'r+') as f:
    data = json.load(f)

    # enable time custom format
    data['use-custom-format']['value'] = True
    f.seek(0)
    json.dump(data, f, indent=4)
    f.truncate()
