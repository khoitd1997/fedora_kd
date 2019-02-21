%include fedora-kickstarts/fedora-live-cinnamon.ks
%include fedora-repo-kd.ks

part / --size=12288

timezone US/Pacific

%packages

# repo
fedora-workstation-repositories
fedora-repos-modular

# external
code
google-chrome-stable
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

# flatpak
flatpak

# arm toolchain
openocd
qemu
arm-none-eabi-newlib
arm-none-eabi-gcc-cs 
arm-none-eabi-gcc-cs-c++

# zsh
zsh 
zsh-syntax-highlighting

# misc
adobe-source-code-pro-fonts

%end

%post --log=/root/ks-post.log
cat >> /usr/share/glib-2.0/schemas/99_my_custom_settings.gschema.override << FOE
[org.gnome.desktop.interface]
gtk-theme='Adwaita-dark'

[org.cinnamon.desktop.background]
picture-uri='file:///usr/share/backgrounds/f29/default/f29.xml'

[org.gnome.desktop.background]
picture-uri='file:///usr/share/user_file/TCP118v1_by_Tiziano_Consonni.jpg'

[x.dm.slick-greeter]
background='/usr/share/backgrounds/default.png'
background-color='#2ceb26'
logo='/usr/share/pixmaps/system-logo-white.png'
draw-user-backgrounds=false
draw-grid=true
enable-hidpi='auto'
font-name='Noto Sans 30'
icon-theme-name='Mint-Y-Aqua'
show-hostname=true
theme-name='Mint-Y-Dark-Aqua'

FOE

glib-compile-schemas /usr/share/glib-2.0/schemas/

# flatpak_package=" com.spotify.Client com.discordapp.Discord \
# com.slack.Slack "
# flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
# for flatpak in ${flatpak_package} ; do
# 	sudo flatpak install flathub ${flatpak} -y 
# done

# code --install-extension ms-vscode.cpptools
%end

# %post --nochroot --log=/mnt/sysimage/root/ks-post-no-root.log
# %end
