#!/bin/bash
flatpak_package=" com.spotify.Client com.discordapp.Discord \
com.slack.Slack "

#flatpak
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
for package in ${flatpak_package} ; do
	flatpak install flathub ${package} -y 
done
