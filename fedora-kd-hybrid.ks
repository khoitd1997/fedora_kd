# the hybrid build has both cinnamon and awesome
%include fedora-kd-cinnamon.ks

part / --size=14000
%packages
awesome

# themes
lxappearance
qt5ct

# app indicators
volumeicon
lxqt-powermanagement
udiskie

%end
