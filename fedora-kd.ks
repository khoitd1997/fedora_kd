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


cat >> /etc/profile.d/first_login_setup.sh << 'EOF'
#!/bin/bash

if [ ! -f ~/first_login_setup_done ]; then
    mkdir -p ~/.config/synapse/
    cp /usr/share/user_file/config.json ~/.config/synapse/config.json

    # customize gnome terminal
    dconf reset -f /org/gnome/terminal/
    gnome-terminal& # launch terminal to make sure a profile folder is created
    sleep 4
    dconf load /org/gnome/terminal/ < /usr/share/user_file/gnome_terminal_backup.txt

    dconf write /org/cinnamon/desktop/background/picture-uri "'file:///usr/share/user_file/TCP118v1_by_Tiziano_Consonni.jpg'"
    # theme
    dconf write /org/cinnamon/desktop/interface/gtk-theme "'Mint-Y-Dark'"
    dconf write /org/cinnamon/desktop/wm/preferences/theme "'Mint-Y-Dark'"
    dconf write /org/cinnamon/theme/name "'Mint-Y-Dark'"
    dconf write /org/cinnamon/settings-daemon/plugins/power/sleep-display-ac "10800"
    dconf write /org/cinnamon/settings-daemon/plugins/power/idle-dim-battery "false"
    dconf write /org/cinnamon/cinnamon-session/quit-delay-toggle "true"
    dconf write /org/cinnamon/enable-indicators "true"
    dconf write /org/cinnamon/sounds/login-enabled "false"
    dconf write /org/cinnamon/cinnamon-session/quit-time-delay "20"
    dconf write /org/cinnamon/desktop/notifications/remove-old "true"

    # panels
    dconf write /org/cinnamon/enabled-applets "['panel1:right:0:systray@cinnamon.org:0', 'panel1:left:0:menu@cinnamon.org:1',   'panel1:left:1:show-desktop@cinnamon.org:2', 'panel1:left:3:window-list@cinnamon.org:4', 'panel1:right:1:keyboard@cinnamon.org:5',    'panel1:right:2:notifications@cinnamon.org:6', 'panel1:right:3:removable-drives@cinnamon.org:7', 'panel1:right:5:network@cinnamon.org:9',  'panel1:right:6:blueberry@cinnamon.org:10', 'panel1:right:7:power@cinnamon.org:11', 'panel1:right:8:calendar@cinnamon.org:12',   'panel1:right:9:sound@cinnamon.org:13']"
    dconf write /org/cinnamon/panels-enabled "['1:0:top']"
    dconf write /org/cinnamon/panels-height "['1:25']"

    # effects 
    dconf write /org/cinnamon/desktop-effects "false"
    dconf write /org/cinnamon/desktop/interface/gtk-overlay-scrollbars "false"
    dconf write /org/cinnamon/startup-animation "false"
    dconf write /org/cinnamon/enable-vfade "false"

    # sound
    dconf write /org/cinnamon/sounds/switch-enabled "false"
    dconf write /org/cinnamon/sounds/map-enabled "false"
    dconf write /org/cinnamon/sounds/close-enabled "false"
    dconf write /org/cinnamon/sounds/minimize-enabled "false"
    dconf write /org/cinnamon/sounds/maximize-enabled "false"
    dconf write /org/cinnamon/sounds/unmaximize-enabled "false"
    dconf write /org/cinnamon/sounds/tile-enabled "false"
    dconf write /org/cinnamon/sounds/notification-enabled "false"

    dconf write /org/cinnamon/desktop/interface/text-scaling-factor "1.3000000000000003"
    dconf write /org/cinnamon/alttab-switcher-style "'icons+preview'"
    dconf write /org/cinnamon/panels-autohide "['1:false']"
    dconf write /org/cinnamon/settings-daemon/peripherals/touchscreen/orientation-lock "true"
    dconf write /org/cinnamon/settings-daemon/plugins/power/sleep-display-ac "0"
    dconf write /org/gnome/libgnomekbd/keyboard/options "['caps\tcaps:escape']"
    dconf write /org/cinnamon/desktop/keybindings/wm/show-desktop "['<Primary><Alt>d']"

    dconf write /org/nemo/desktop/computer-icon-visible "false"
    dconf write /org/nemo/desktop/home-icon-visible "false"
    dconf write /org/nemo/desktop/trash-icon-visible "false"
    dconf write /org/cinnamon/desktop/session/idle-delay "uint32 0"

    # xpad stuffs
    xpad& # launch it to create initial files 
    sleep 3
    rm -f ~/.config/autostart/xpad.desktop # don't start xpad on startup
    mkdir -p ~/temp

    flatpak_package=" com.spotify.Client com.discordapp.Discord com.slack.Slack "
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    for flatpak in ${flatpak_package} ; do
    	sudo flatpak install flathub ${flatpak} -y 
    done

    code --install-extension ms-vscode.cpptools
    code --install-extension CoenraadS.bracket-pair-colorizer

    touch ~/first_login_setup_done
fi
EOF
chmod a+x /etc/profile.d/first_login_setup.sh

cat >> /usr/share/glib-2.0/schemas/99_my_custom_settings.gschema.override << FOE
[x.dm.slick-greeter]
background='/usr/share/user_file/TCP118v1_by_Tiziano_Consonni.jpg'
background-color='#2ceb26'
logo='/usr/share/user_file/login_logo.png'
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

%end

# %post --nochroot --log=/mnt/sysimage/root/ks-post-no-root.log
# %end
