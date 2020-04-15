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
git-credential-libsecret
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



# plymouth theme




%end

%post --nochroot --log=/mnt/sysimage/root/ks-post-no-root.log

%end
