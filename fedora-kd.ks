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
FOE

glib-compile-schemas /usr/share/glib-2.0/schemas/

# dnf config-manager --set-enabled fedora-modular updates-modular google-chrome rpmfusion-nonfree-nvidia-driver
# dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y

# dnf install google-chrome-stable xorg-x11-drv-nvidia akmod-nvidia nautilus-dropbox VirtualBox akmod-VirtualBox -y
# dnf install bat -y

# dnf update -y

# flatpak_package=" com.spotify.Client com.discordapp.Discord \
# com.slack.Slack "
# flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
# for flatpak in ${flatpak_package} ; do
# 	sudo flatpak install flathub ${flatpak} -y 
# done

# # vscode
# rpm --import https://packages.microsoft.com/keys/microsoft.asc
# sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
# dnf check-update
# dnf install code -y

# code --install-extension ms-vscode.cpptools
%end

# %post --nochroot --log=/mnt/sysimage/root/ks-post-no-root.log
# %end
