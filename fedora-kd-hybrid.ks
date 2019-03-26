# the hybrid build has both cinnamon and awesome
%include fedora-kd-cinnamon.ks

part / --size=14000
%packages
awesome
%end
