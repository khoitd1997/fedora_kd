%include fedora-kickstarts/fedora-live-base.ks
%include fedora-kd-non-main-de.ks
%include fedora-kd-base.ks

%packages
awesome
%end

# source: based on fedora cinnamon live kickstart file
# at: https://pagure.io/fedora-kickstarts
%post

cat >> /etc/lightdm/lightdm.conf <<EOF
[SeatDefaults]
user-session=awesome
EOF

cat > /etc/sysconfig/desktop <<EOF
PREFERRED=/usr/bin/awesome
DISPLAYMANAGER=/usr/sbin/lightdm
EOF

cat >> /etc/rc.d/init.d/livesys << EOF

# set up lightdm autologin
sed -i 's/^#autologin-user=.*/autologin-user=liveuser/' /etc/lightdm/lightdm.conf
sed -i 's/^#autologin-user-timeout=.*/autologin-user-timeout=0/' /etc/lightdm/lightdm.conf

sed -i 's/^#user-session=.*/user-session=awesome/' /etc/lightdm/lightdm.conf

# no updater applet in live environment
rm -f /etc/xdg/autostart/org.mageia.dnfdragora-updater.desktop

cat >> /home/liveuser/live_user_setup.sh << FOE
#!/bin/bash
sleep 8
# X window fix
xhost +SI:localuser:root
/usr/bin/liveinst 
FOE
chmod a+x /home/liveuser/live_user_setup.sh

# this goes at the end after all other changes. 
chown -R liveuser:liveuser /home/liveuser
restorecon -R /home/liveuser
EOF
%end