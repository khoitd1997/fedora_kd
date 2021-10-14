#!/usr/bin/env python3
# source: https://github.com/justbuchanan/i3scripts/blob/master/util.py
# modified to display more icons

# github.com/justbuchanan/i3scripts

import argparse
import fontawesome as fa
import sys
import signal
import i3ipc
import re
import logging
import subprocess as proc
from collections import namedtuple

# A type that represents a parsed workspace "name".
NameParts = namedtuple('NameParts', ['num', 'shortname', 'icons'])


def focused_workspace(i3):
    return [w for w in i3.get_workspaces() if w.focused][0]


# Takes a workspace 'name' from i3 and splits it into three parts:
# * 'num'
# * 'shortname' - the workspace's name, assumed to have no spaces
# * 'icons' - the string that comes after the
# Any field that's missing will be None in the returned dict
def parse_workspace_name(name):
    m = re.match('(?P<num>\d+):?(?P<shortname>\w+)? ?(?P<icons>.+)?',
                 name).groupdict()
    return NameParts(**m)


# Given a NameParts object, returns the formatted name
# by concatenating them together.
def construct_workspace_name(parts):
    new_name = str(parts.num)
    if parts.shortname or parts.icons:
        new_name += ':'

        if parts.shortname:
            new_name += parts.shortname

        if parts.icons:
            new_name += ' ' + parts.icons

    return new_name


# Return an array of values for the X property on the given window.
# Requires xorg-xprop to be installed.
def xprop(win_id, property):
    try:
        prop = proc.check_output(
            ['xprop', '-id', str(win_id), property], stderr=proc.DEVNULL)
        prop = prop.decode('utf-8')
        return re.findall('"([^"]*)"', prop)
    except proc.CalledProcessError as e:
        logging.warn("Unable to get property for window '%d'" % win_id)
        return None

# github.com/justbuchanan/i3scripts
#
# This script listens for i3 events and updates workspace names to show icons
# for running programs.  It contains icons for a few programs, but more can
# easily be added by editing the WINDOW_ICONS list below.
#
# It also re-numbers workspaces in ascending order with one skipped number
# between monitors (leaving a gap for a new workspace to be created). By
# default, i3 workspace numbers are sticky, so they quickly get out of order.
#
# Dependencies
# * xorg-xprop  - install through system package manager
# * i3ipc       - install with pip
# * fontawesome - install with pip
#
# Installation:
# * Download this repo and place it in ~/.config/i3/ (or anywhere you want)
# * Add "exec_always ~/.config/i3/i3scripts/autoname_workspaces.py &" to your i3 config
# * Restart i3: $ i3-msg restart
#
# Configuration:
# The default i3 config's keybindings reference workspaces by name, which is an
# issue when using this script because the "names" are constantly changing to
# include window icons.  Instead, you'll need to change the keybindings to
# reference workspaces by number.  Change lines like:
#   bindsym $mod+1 workspace 1
# To:
#   bindsym $mod+1 workspace number 1


# Add icons here for common programs you use.  The keys are the X window class
# (WM_CLASS) names (lower-cased) and the icons can be any text you want to
# display.
#
# Most of these are character codes for font awesome:
#   http://fortawesome.github.io/Font-Awesome/icons/
#
# If you're not sure what the WM_CLASS is for your application, you can use
# xprop (https://linux.die.net/man/1/xprop). Run `xprop | grep WM_CLASS`
# then click on the application you want to inspect.
WINDOW_ICONS = {
    'alacritty': fa.icons['terminal'],
    'atom': fa.icons['code'],
    'banshee': fa.icons['play'],
    'blender': fa.icons['cube'],
    'chromium': fa.icons['chrome'],
    'discord': fa.icons['comment'],
    'eclipse': fa.icons['code'],
    'emacs': fa.icons['code'],
    'eog': fa.icons['image'],
    'evince': fa.icons['file-pdf'],
    'feh': fa.icons['image'],
    'file-roller': fa.icons['compress'],
    'firefox': fa.icons['firefox'],
    'gimp-2.8': fa.icons['image'],
    'gnome-control-center': fa.icons['toggle-on'],
    'gnome-terminal-server': fa.icons['terminal'],
    'google-chrome': fa.icons['chrome'],
    'gpick': fa.icons['eye-dropper'],
    'imv': fa.icons['image'],
    'java': fa.icons['java'],
    'jetbrains-studio': fa.icons['code'],
    'keybase': fa.icons['key'],
    'kicad': fa.icons['microchip'],
    'kitty': fa.icons['terminal'],
    'libreoffice': fa.icons['file-alt'],
    'lua5.1': fa.icons['moon'],
    'mupdf': fa.icons['file-pdf'],
    'mysql-workbench-bin': fa.icons['database'],
    'nautilus': fa.icons['copy'],
    'nemo': fa.icons['copy'],
    'openscad': fa.icons['cube'],
    'pavucontrol': fa.icons['volume-up'],
    'postman': fa.icons['space-shuttle'],
    'rhythmbox': fa.icons['play'],
    'slack': fa.icons['slack'],
    'slic3r.pl': fa.icons['cube'],
    'spotify': fa.icons['music'],  # could also use the 'spotify' icon
    'steam': fa.icons['steam'],
    'totem': fa.icons['play'],
    'urxvt': fa.icons['terminal'],
    'xfce4-terminal': fa.icons['terminal'],
    'xournal': fa.icons['file-alt'],
    'zenity': fa.icons['window-maximize'],
    'code': fa.icons['code'],
}

# This icon is used for any application not in the list above
DEFAULT_ICON = '*'

# Global setting that determines whether workspaces will be automatically
# re-numbered in ascending order with a "gap" left on each monitor. This is
# overridden via command-line flag.
RENUMBER_WORKSPACES = True


def ensure_window_icons_lowercase():
    for cls in WINDOW_ICONS:
        if cls != cls.lower():
            WINDOW_ICONS[cls.lower()] = WINDOW_ICONS[cls]
            del WINDOW_ICONS[cls]


def icon_for_window(window):
    # Try all window classes and use the first one we have an icon for
    classes = xprop(window.window, 'WM_CLASS')
    if classes != None and len(classes) > 0:
        for cls in classes:
            cls = cls.lower()  # case-insensitive matching
            if cls in WINDOW_ICONS:
                return WINDOW_ICONS[cls]
    logging.info(
        'No icon available for window with classes: %s' % str(classes))
    return DEFAULT_ICON


# renames all workspaces based on the windows present
# also renumbers them in ascending order, with one gap left between monitors
# for example: workspace numbering on two monitors: [1, 2, 3], [5, 6]
def rename_workspaces(i3):
    ws_infos = i3.get_workspaces()
    prev_output = None
    n = 1
    for ws_index, workspace in enumerate(i3.get_tree().workspaces()):
        ws_info = ws_infos[ws_index]

        name_parts = parse_workspace_name(workspace.name)
        new_icons = ' '.join([icon_for_window(w) for w in workspace.leaves()])

        # As we enumerate, leave one gap in workspace numbers between each monitor.
        # This leaves a space to insert a new one later.
        if ws_info.output != prev_output and prev_output != None:
            n += 1
        prev_output = ws_info.output

        # optionally renumber workspace
        new_num = n if RENUMBER_WORKSPACES else name_parts.num
        n += 1

        new_name = construct_workspace_name(
            NameParts(
                num=new_num, shortname=name_parts.shortname, icons=new_icons))
        if workspace.name == new_name:
            continue
        i3.command(
            'rename workspace "%s" to "%s"' % (workspace.name, new_name))


# Rename workspaces to just numbers and shortnames, removing the icons.
def on_exit(i3):
    for workspace in i3.get_tree().workspaces():
        name_parts = parse_workspace_name(workspace.name)
        new_name = construct_workspace_name(
            NameParts(
                num=name_parts.num, shortname=name_parts.shortname,
                icons=None))
        if workspace.name == new_name:
            continue
        i3.command(
            'rename workspace "%s" to "%s"' % (workspace.name, new_name))
    i3.main_quit()
    sys.exit(0)


if __name__ == '__main__':
    parser = argparse.ArgumentParser(
        description="Rename workspaces dynamically to show icons for running programs.")
    parser.add_argument(
        '--norenumber_workspaces',
        action='store_true',
        default=False,
        help="Disable automatic workspace re-numbering. By default, workspaces are automatically re-numbered in ascending order."
    )
    args = parser.parse_args()

    RENUMBER_WORKSPACES = not args.norenumber_workspaces

    logging.basicConfig(level=logging.INFO)

    ensure_window_icons_lowercase()

    i3 = i3ipc.Connection()

    # Exit gracefully when ctrl+c is pressed
    for sig in [signal.SIGINT, signal.SIGTERM]:
        signal.signal(sig, lambda signal, frame: on_exit(i3))

    rename_workspaces(i3)

    # Call rename_workspaces() for relevant window events
    def event_handler(i3, e):
        if e.change in ['new', 'close', 'move']:
            rename_workspaces(i3)

    i3.on('window', event_handler)
    i3.on('workspace::move', event_handler)
    i3.main()