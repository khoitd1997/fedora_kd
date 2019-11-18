%include fedora-repo-kd.ks

lang en_US.UTF-8
keyboard us

timezone US/Pacific

%packages

# repo
fedora-workstation-repositories
fedora-repos-modular

# external
nautilus-dropbox
nautilus
gnome-terminal-nautilus

# groups
@development-tools
@multimedia
@sound-and-video

# modular
bat
hyperfine

# c/c++ dev
qt-creator
cmake
valgrind
perf
gcc
clang
clang-tools-extra
llvm
cppcheck
clang-analyzer
iwyu
libasan
libubsan
ninja-build
boost
boost-devel

# cli
neovim
strace
simplescreenrecorder
moreutils
jq
ripgrep
gnome-terminal
doxygen
dnfdragora-updater
zeitgeist
youtube-dl
htop
glances
net-tools
minicom
screen
python3-pip
curl
python3-setuptools
ranger
tldr
the_silver_searcher
neofetch
ncdu
tig
iftop
task
autojump
fd-find
fzf
hub
git
nano
dnf-automatic
openconnect
tmux
libsecret
glibc-devel.i686
libnsl
xdotool

# libraries
systemd-devel
gmock 
gmock-devel
gtest
gtest-devel 
qt-x11
mesa-libGL-devel

# packaging tools
fedora-packager
mock
fedora-review

# fedora dev
python3-hawkey
python3-dnf
python-rpm
python3-rpm
lorax-lmc-novirt 
pykickstart
livecd-tools

# gui apps
kdenlive
frei0r-plugins
redshift-gtk
gnome-disk-utility
seahorse
i3lock
autokey-gtk
firefox
xclip
evince
synaptic
xpad
gparted
moserial
ncurses-devel
meld
bustle
graphviz
npm
flameshot
feh
qalculate-gtk
# synapse # replaced by rofi
latexmk
baobab
kernel-devel
kernel-headers
pylint
liveusb-creator
bleachbit
gimp
vlc
konsole

# ansible
ansible

# snap
snapd

# flatpak
flatpak

# power management
tlp
tlp-rdw

# latex
texlive-latexindent
texlive-scheme-basic
texlive-collection-latexextra
texlive-collection-latexrecommended
texlive-collection-xetex

# gstreamer
gstreamer-plugins-bad
gstreamer-plugins-bad-free-extras
gstreamer-plugins-bad-nonfree
gstreamer-plugins-ugly
gstreamer-ffmpeg
gstreamer1-plugins-good-extras
gstreamer1-plugins-bad-free-extras

# rofi
rofi
rofi-themes

# go
golang
golint

# arm toolchain
openocd
arm-none-eabi-newlib
arm-none-eabi-gcc-cs
arm-none-eabi-gcc-cs-c++

# embedded linux stuffs
@virtualization
tigervnc
qemu

# rpm fusion
rpmfusion-free-release
rpmfusion-free-release-tainted
rpmfusion-nonfree-release
rpmfusion-nonfree-release-tainted

# zsh
zsh
zsh-syntax-highlighting

# java
java-1.8.0-openjdk
java-1.8.0-openjdk-devel
java-openjdk

# misc
adobe-source-code-pro-fonts
arc-theme
plymouth-plugin-script

# removal
-gnome-calculator

%end

%post --log=/root/ks-post.log --erroronfail
# snap fix
ln -s /var/lib/snapd/snap /snap

cat > /etc/lightdm/slick-greeter.conf <<EOF

[Greeter]
draw-user-backgrounds=true
background=/usr/share/user_file/resource/TCP118v1_by_Tiziano_Consonni.jpg
background-color='#2ceb26'
logo=/usr/share/user_file/resource/login_logo.png
draw-grid=false
enable-hidpi='auto'
font-name='Noto Sans 11'
icon-theme-name='Mint-Y-Aqua'
show-hostname=true
theme-name='Mint-Y-Dark-Aqua'
show-clock=true
onscreen-keyboard=false
EOF

# annaconda customizations
cat >> /etc/sysconfig/anaconda << FOE
# [PasswordSpoke]
# visited=1

# [UserSpoke]
# visited=1

[DatetimeSpoke]
visited=1

[KeyboardSpoke]
visited=1

[WelcomeLanguageSpoke]
visited=1

[LangsupportSpoke]
visited=1
FOE

cat >> /etc/profile.d/screen_setup.sh << 'EOF'
total_monitor=$(xrandr -q | grep -w "connected" | wc -l)

if [ "$total_monitor" -eq 2 ];then
    xrandr --output HDMI-0 --left-of DVI-D-0
fi
EOF
chmod a+x /etc/profile.d/screen_setup.sh

cat >> /etc/profile.d/first_login_setup.sh << 'EOF'
#!/bin/bash
# will clone the first login setup repo and run it

if [ "${USER}" != "liveuser" ]; then
if [ ! -f ~/.first_login_setup_done ]; then
if [ ! -f ~/.first_login_setup_in_progress ]; then

if [ -d "~/hatter/fedora-kickstarts" ]; then
git -C ~/hatter/fedora-kickstarts pull
else
git clone https://github.com/khoitd1997/hatter.git ~/hatter
git clone https://github.com/khoitd1997/fedora_kd.git ~/hatter/fedora-kickstarts
fi

bash ~/hatter/fedora-kickstarts/userland/setup_wrapper.sh&
fi
fi
fi

EOF
chmod a+x /etc/profile.d/first_login_setup.sh

# plymouth theme
mkdir -vp /usr/share/plymouth/themes/boot
cat >> /usr/share/plymouth/themes/boot/boot.plymouth << FOE
[Plymouth Theme]
Name=boot
Description=Infinite loop rainbow
ModuleName=script

[script]
ImageDir=/usr/share/user_file/plymouth
ScriptFile=/usr/share/user_file/plymouth/animation.script
FOE

cat >> /etc/plymouth/plymouthd.conf << FOE
ShowDelay=0
FOE
/usr/sbin/plymouth-set-default-theme boot -R

# TODO: Move this to first boot script
systemctl enable firewalld
systemctl enable libvirtd

# enable power mangement
systemctl enable tlp.service
systemctl enable tlp-sleep.service
systemctl mask systemd-rfkill.service
systemctl mask systemd-rfkill.socket
systemctl enable NetworkManager-dispatcher.service
sudo sed -i 's/^TLP_DEFAULT_MODE=.*/TLP_DEFAULT_MODE=BAT/' /etc/default/tlp

sed -i '/upgrade_type/s/default/security/' /etc/dnf/automatic.conf
sed -i '/apply_updates/s/no/yes/' /etc/dnf/automatic.conf
systemctl enable --now dnf-automatic-install.timer
systemctl enable --now dnf-automatic.timer
systemctl enable --now dnf-makecache.timer
printf "\nkeepcache=True\n" >> /etc/dnf/dnf.conf

passwd -l root
rm -vf /usr/share/applications/flameshot.desktop

sed -ie 's:SHELL=/bin/bash:SHELL=/bin/zsh:g' /etc/default/useradd
%end

%post --nochroot --log=/mnt/sysimage/root/ks-post-no-root.log
cp -vr /builddir/fedora-kickstarts/user_file /mnt/sysimage/usr/share/
chmod -R a+r+x /mnt/sysimage/usr/share/user_file
%end
