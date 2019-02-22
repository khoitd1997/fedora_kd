#!/usr/bin/env python3
# used for adding new command to search path and even startup
# using an app_list file in the same dir

import os
from pathlib import Path
import json

currDir = os.path.realpath(os.path.join(
    os.getcwd(), os.path.dirname(__file__)))
with open(os.path.join(currDir, 'app_list.json'), 'r') as f:
    apps = json.load(f)

for app in apps["apps"]:
    launchFilePath = os.path.join(
        str(Path.home()), '.local/share/applications', app["name"] + ".desktop")
    with open(launchFilePath, 'w+') as launchFile:
        launchFile.write("[Desktop Entry]\n")
        launchFile.write("Name = " + app["name"] + "\n")
        launchFile.write("Exec = " + app["command"] + "\n")
        launchFile.write("Comment = " + app["comment"] + "\n")
        launchFile.write("Terminal = " + app["launchInTerminal"] + "\n")
        launchFile.write("Icon = " + app["iconPath"] + "\n")
        launchFile.write("Type = " + app["type"] + "\n")

    if app["startup"]:
        startupFilePath = os.path.join(
            str(Path.home()), '.config/autostart/', app["name"] + ".desktop")
        with open(startupFilePath, 'w+') as startupFile:
            startupFile.write("[Desktop Entry]\n")
            startupFile.write("Name = " + app["name"] + "\n")
            startupFile.write("Exec = " + app["command"] + "\n")
            startupFile.write("Terminal = " + app["launchInTerminal"] + "\n")
            startupFile.write("Type = " + app["type"] + "\n")
            startupFile.write("X-GNOME-Autostart-enabled = true\n")
