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


def createBaseDesktopFile(app: dict, filePath: str) -> None:
    with open(filePath, 'w+') as launchFile:
        launchFile.write("[Desktop Entry]\n")
        launchFile.write("Name = " + app["name"] + "\n")
        launchFile.write("Exec = " + app["command"] + "\n")
        launchFile.write("Comment = " + app["comment"] + "\n")
        launchFile.write("Terminal = " + app["launchInTerminal"] + "\n")
        launchFile.write("Icon = " + app["iconPath"] + "\n")
        launchFile.write("Type = " + app["type"] + "\n")
        if "genericName" in app:
            launchFile.write("GenericName = " + app["genericName"] + "\n")
        if "mimeType" in app:
            launchFile.write("MimeType = " + app["mimeType"] + "\n")
        if "startupNotify" in app:
            launchFile.write("StartupNotify = " + app["startupNotify"] + "\n")
        if "categories" in app:
            launchFile.write("Categories = " + app["categories"] + "\n")


def createStartupFile(app: dict, filePath: str) -> None:
    createBaseDesktopFile(app, filePath)

    with open(filePath, 'a') as startupFile:
        startupFile.write("X-GNOME-Autostart-enabled = true\n")


for app in apps["apps"]:
    dekstopFileName = app["name"]
    if "desktopFileName" in app:
        dekstopFileName = app["desktopFileName"]

    launchFilePath = os.path.join(
        str(Path.home()), '.local/share/applications', dekstopFileName + ".desktop")
    createBaseDesktopFile(app, launchFilePath)

    if app["startup"]:
        startupFilePath = os.path.join(
            str(Path.home()), '.config/autostart/', dekstopFileName + ".desktop")
        createStartupFile(app, startupFilePath)
