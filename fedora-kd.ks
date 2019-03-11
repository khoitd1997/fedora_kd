%include fedora-kickstarts/fedora-live-cinnamon.ks
%include fedora-repo-kd.ks

part / --size=12588
lang en_US.UTF-8
keyboard us

timezone US/Pacific
# user --iscrypted --name=test --password=123456 --groups=wheel,dialout,mock

%packages

# repo
fedora-workstation-repositories
fedora-repos-modular

# external
xorg-x11-drv-nvidia
akmod-nvidia
nautilus-dropbox
VirtualBox
akmod-VirtualBox

# groups
@development-tools
@multimedia
@sound-and-video

# modular
bat

# cli
doxygen
zeitgeist
youtube-dl
cmake
valgrind
gcc
clang
llvm 
htop
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
glibc-devel.i686 
libnsl

# packaging tools
fedora-packager
mock
fedora-review

# gui apps
xclip
evince
synaptic
xpad
gparted
moserial
libncurses* 
meld
bustle
d-feet
graphviz
npm
flameshot
feh
synapse
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

# latex
texlive-scheme-basic 
texlive-collection-latexextra 
texlive-collection-latexrecommended 
texlive-collection-xetex

# go
golang
golint

# arm toolchain
openocd
qemu
arm-none-eabi-newlib
arm-none-eabi-gcc-cs 
arm-none-eabi-gcc-cs-c++

# rpm fusion
rpmfusion-free-release
rpmfusion-free-release-tainted
rpmfusion-nonfree-release
rpmfusion-nonfree-release-tainted

# zsh
zsh 
zsh-syntax-highlighting

# misc
adobe-source-code-pro-fonts
arc-theme
plymouth-plugin-script

%end

%post --log=/root/ks-post.log --erroronfail

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


cat >> /etc/profile.d/first_login_setup.sh << 'EOF'
#!/bin/bash
# set -e
if [ ! -f ~/first_login_setup_done ]; then
if [ ! -f ~/first_login_setup_in_progress ]; then
git clone https://github.com/khoitd1997/fedora_kd.git ~/fedora_kd
bash ~/fedora_kd/user_file/setup_wrapper.sh&
fi
fi

EOF
chmod a+x /etc/profile.d/first_login_setup.sh

cat >> /usr/share/glib-2.0/schemas/99_my_custom_settings.gschema.override << FOE
[x.dm.slick-greeter]
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
FOE

glib-compile-schemas /usr/share/glib-2.0/schemas/

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

systemctl enable firewalld

sed -i '/upgrade_type/s/default/security/' /etc/dnf/automatic.conf 
sed -i '/apply_updates/s/no/yes/' /etc/dnf/automatic.conf
systemctl enable --now dnf-automatic-install.timer
systemctl enable --now dnf-makecache.timer
echo "\nkeepcache=True\n" >> /etc/dnf/dnf.conf

passwd -l root
rm -vf /usr/share/applications/flameshot.desktop

sed -ie 's:SHELL=/bin/bash:SHELL=/bin/zsh:g' /etc/default/useradd
%end

%post --nochroot --log=/mnt/sysimage/root/ks-post-no-root.log
cp -vr /builddir/fedora-kickstarts/user_file /mnt/sysimage/usr/share/
chmod -R a+r+x /mnt/sysimage/usr/share/user_file
%end
