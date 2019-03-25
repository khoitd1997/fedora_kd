# used as based for non mainstream de like i3, awesomewm
%packages

@networkmanager-submodules
@libreoffice
parole

# greeter
slick-greeter

# network
NetworkManager-adsl
NetworkManager-bluetooth
NetworkManager-iodine-gnome
NetworkManager-l2tp-gnome
NetworkManager-libreswan-gnome
NetworkManager-openconnect-gnome
NetworkManager-openvpn-gnome
NetworkManager-ppp
NetworkManager-pptp-gnome
NetworkManager-vpnc-gnome
NetworkManager-wifi
NetworkManager-wwan
nm-connection-editor

# misc
dnfdragora-updater
alsa-plugins-pulseaudio
firefox
gnome-disk-utility
gstreamer1-plugins-ugly-free
imsettings
initial-setup-gui
redshift-gtk
sane-backends-drivers-scanners
simple-scan
transmission

# dev
vim-powerline
tmux
tmux-powerline

# image
eom
nomacs

# security
gnome-keyring
setroubleshoot
firewall-config

# media, connection
hexchat
pidgin

# gvfs
gvfs-archive
gvfs-gphoto2
gvfs-mtp
gvfs-smb

# themes
lxappearance
qt5ct
mint-y-icons
paper-icon-theme
fedora-icon-theme

# file manager
nautilus

# app indicators
volumeicon
lxqt-powermanagement
udiskie

# library deps
python3-pypandoc # for i3 autoname

# removal
-openbox

%end

%post
cat >> /etc/profile.d/live_user_setup.sh << 'EOF'
#!/bin/bash
# launch live install when live user boots

# set -e
if [ "${USER}" == "liveuser" ]; then
if [ ! -f ~/live_user_setup_in_progress ]; then
touch ~/live_user_setup_in_progress
/home/liveuser/live_user_setup.sh &
fi
fi

EOF
chmod a+x /etc/profile.d/live_user_setup.sh
%end