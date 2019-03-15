%include fedora-kickstarts/fedora-live-base.ks
%include fedora-kd-base.ks

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
gnome-calculator
gstreamer1-plugins-ugly-free
imsettings
initial-setup-gui
redshift
sane-backends-drivers-scanners
simple-scan
transmission

# dev
vim-powerline
tmux
tmux-powerline

# image
nomacs

# security
gnome-keyring
libsecret
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
mint-y-icons
paper-icon-theme
fedora-icon-theme

# file manager
nautilus

# i3
i3
i3status
dmenu
i3lock
xbacklight
conky
volumeicon
udiskie

# library deps
python3-pypandoc # for i3 autoname

%end

# source: based on fedora cinnamon live kickstart file
# at: https://pagure.io/fedora-kickstarts
%post

cat > /etc/lightdm/slick-greeter.conf <<EOF

[Greeter]
background='/usr/share/user_file/resource/TCP118v1_by_Tiziano_Consonni.jpg'
background-color='#2ceb26'
logo='/usr/share/user_file/resource/login_logo.png'
draw-user-backgrounds=false
draw-grid=false
enable-hidpi='auto'
font-name='Noto Sans 11'
icon-theme-name='Mint-Y-Aqua'
show-hostname=true
theme-name='Mint-Y-Dark-Aqua'
show-clock=true
onscreen-keyboard=false

EOF

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

cat >> ~/.config/i3/config <<EOF
exec feh --bg-scale /usr/share/user_file/TCP118v1_by_Tiziano_Consonni.jpg
EOF

cat > /etc/sysconfig/desktop <<EOF
PREFERRED=/usr/bin/i3
DISPLAYMANAGER=/usr/sbin/lightdm
EOF

cat >> /etc/rc.d/init.d/livesys << EOF

# set up lightdm autologin
sed -i 's/^#autologin-user=.*/autologin-user=liveuser/' /etc/lightdm/lightdm.conf
sed -i 's/^#autologin-user-timeout=.*/autologin-user-timeout=0/' /etc/lightdm/lightdm.conf

sed -i 's/^#user-session=.*/user-session=i3/' /etc/lightdm/lightdm.conf

# no updater applet in live environment
rm -f /etc/xdg/autostart/org.mageia.dnfdragora-updater.desktop


cat >> /home/liveuser/live_user_setup.sh << FOE
#!/bin/bash
sleep 8
/usr/bin/liveinst 
FOE
chmod a+x /home/liveuser/live_user_setup.sh

# # show install when user logs in
# sed -i -e 's/NoDisplay=true/NoDisplay=false/' /usr/share/applications/liveinst.desktop
# mkdir -p /home/liveuser/.config/autostart
# cp /usr/share/applications/liveinst.desktop /home/liveuser/.config/autostart/

# # and mark it as executable
# chmod +x /home/liveuser/.config/autostart/liveinst.desktop

# this goes at the end after all other changes. 
chown -R liveuser:liveuser /home/liveuser
restorecon -R /home/liveuser

EOF

%end