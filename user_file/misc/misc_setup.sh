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
# some process may hog sudo at boot so check update while waiting
print_message "Please enter sudo password if prompted\n"
dnf check-update || true
sudo dnf config-manager --set-enabled google-chrome -y
dnf check-update || true
sudo dnf update -y
sudo dnf install google-chrome-stable -y

# Add user to group
sudo usermod -a -G dialout ${USER}
sudo usermod -a -G mock ${USER}

# adjust clock to local
sudo timedatectl set-local-rtc 1 --adjust-system-clock 

# adjust timezone to pacific
sudo rm -f /etc/localtime
sudo ln -s /usr/share/zoneinfo/US/Pacific /etc/localtime

# setup GNOME keyring git credential helper
git config --global credential.helper /usr/libexec/git-core/git-credential-libsecret

# increase notification maximum for vscode
echo fs.inotify.max_user_watches=524288 | sudo tee -a /etc/sysctl.conf

# Dev tools installations start here
pip3 install --user ${python_pip_package_list}

mkdir -vp ~/.config/synapse/
cp -v ${currDir}/synapse_config.json ~/.config/synapse/config.json

cp -v ${currDir}/mimeapps.list ~/.config

cp -vR ${currDir}/nemo/*.nemo_action ~/.local/share/nemo/actions

printf "file://$HOME/Dropbox/Class/" >>  ~/.config/gtk-3.0/bookmarks

# vim
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
stow -t ~ -d ${currDir} -S vim --verbose=3

# tmux
ln -sv ${currDir}/tmux/.tmux.conf ~/.tmux.conf 

# setup launcher shortcut
print_message "Setting up application launcher\n"
print_message "Please enter sudo password if prompted\n"
printf '\n[redshift]\n allowed=true\n system=false\n users=\n\n' | sudo tee -a /etc/geoclue/geoclue.conf

# xpad stuffs
xpad& # launch it to create initial files
sleep 2
rm -vf ~/.config/autostart/xpad.desktop # don't start xpad on startup
pkill xpad

mkdir -vp ~/.local/share/applications
mkdir -vp ~/.config/autostart
python3 ${currDir}/launcher_app/add_launcher_app.py

mkdir -vp ~/temp

print_message "Misc setup done\n"
