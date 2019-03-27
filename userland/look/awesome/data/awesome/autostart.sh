#!/usr/bin/env bash
# ---
# Use "run program" to run it only if it is not already running
# Use "program &" to run it regardless
# ---
# NOTE: This script runs with every restart of AwesomeWM

export QT_QPA_PLATFORMTHEME=qt5ct

function run {
    if ! pgrep $1 > /dev/null ;
    then
        $@&
    fi
}

# Load terminal colorscheme and settings
#xrdb ~/.Xresources

# Enable numlock on login
run numlockx

# right alt to win
xmodmap -e "remove mod1 = Alt_R"
xmodmap -e "keycode 108 = Super_R"
setxkbmap -option caps:escape

# Network manager tray icon
run nm-applet
run dropbox start -i
run lxqt-powermanagement
run volumeicon
run redshift-gtk -l 34.052235:-118.243683
run dnfdragora-updater
run /usr/bin/seapplet
run autokey-gtk

# Keyboard layout
# setxkbmap -layout "us,gr" -option "grp:alt_shift_toggle" &
# setxkbmap -layout "us,de" -option "grp:alt_shift_toggle" &
# setxkbmap -layout "us,gr,ru" -option "grp:alt_shift_toggle"


