#!/bin/bash
currDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ${currDir}
source ../utils.sh

flatpak_package=" com.spotify.Client com.discordapp.Discord \
com.slack.Slack io.atom.Atom "

#flatpak
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
for package in ${flatpak_package} ; do
	flatpak install flathub ${package} -y 
done

print_message "Flatpak setup done\n"