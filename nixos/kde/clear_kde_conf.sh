#!/usr/bin/env bash

file_list="kdeglobals kwinrc"

cd ~/.config
rm -f ${file_list}

cd kdedefaults
rm -f ${file_list}