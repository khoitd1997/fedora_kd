%include fedora-kickstarts/fedora-live-cinnamon.ks
%include fedora-kd-base.ks

part / --size=12588

%post

cat >> /etc/lightdm/lightdm.conf <<EOF
[SeatDefaults]
user-session=cinnamon
EOF

%end