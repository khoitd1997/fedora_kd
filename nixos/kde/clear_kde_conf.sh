#!/usr/bin/env bash

file_list="kdeglobals kwinrc kscreenlockerrc kcminputrc kglobalshortcutsrc khotkeysrc kaccessrc kxkbrc"

cd ~/.config
rm -f ${file_list}

cd kdedefaults
rm -f ${file_list}