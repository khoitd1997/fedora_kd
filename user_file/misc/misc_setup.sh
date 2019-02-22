#!/bin/bash
# scripts written for setting up a fresh RPM based system

# python pip list
python_pip_package_list=" pylint autopep8 "

currDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ${currDir}
source ../utils.sh

set -e 
set -o pipefail
set -o nounset
#----------------------------------------------------------------------------------------------------
print_message "Starting Misc Installation of Fedora Machine\n"
sudo passwd -l root
sudo systemctl enable firewalld
sudo setenforce 1
sudo dnf update --allowerasing -y

# adjust clock to local
sudo timedatectl set-timezone America/Los_Angeles
timedatectl set-local-rtc 1 --adjust-system-clock 

# edit auto update settings
sudo sed -i '/upgrade_type/s/default/security/' /etc/dnf/automatic.conf 
sudo sed -i '/apply_updates/s/no/yes/' /etc/dnf/automatic.conf
sudo systemctl enable --now dnf-automatic-install.timer

# Add user to group
sudo usermod -a -G dialout ${USER}
sudo usermod -a -G mock ${USER}

# setup GNOME keyring git credential helper
git config --global credential.helper /usr/libexec/git-core/git-credential-libsecret

# increase notification maximum for vscode
echo fs.inotify.max_user_watches=524288 | sudo tee -a /etc/sysctl.conf

# Dev tools installations start here
# TODO: Handle go and python

mkdir -p ~/.config/synapse/
cp ${currDir}/synapse_config.json ~/.config/synapse/config.json

# setup launcher shortcut
print_message "Setting up application launcher\n"
printf '\n[redshift]\n allowed=true\n system=false\n users=\n\n' | sudo tee -a /etc/geoclue/geoclue.conf

sudo rm -f /usr/share/applications/flameshot.desktop # remove default flameshot launcher

# xpad stuffs
xpad& # launch it to create initial files
sleep 2
rm -f ~/.config/autostart/xpad.desktop # don't start xpad on startup
pkill xpad

mkdir -p ~/.local/share/applications
python3 ${currDir}/launcher_app/add_launcher_app.py

mkdir -p ~/temp

print_message "Misc installation setup done\n"
