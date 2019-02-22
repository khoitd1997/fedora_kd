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
# @development-tools
# @multimedia
# @sound-and-video

# modular
bat

# cli
# doxygen
# cmake
# valgrind
# gcc
# clang
# llvm 
# htop
# net-tools
# minicom
# screen
# python3-pip 
# curl
# python3-setuptools
# ranger
# tldr
# the_silver_searcher
# neofetch 
# task 
# autojump
# fd-find
# fzf
# hub 
git
nano 
# dnf-automatic 
# openconnect 
# tmux 
# glibc-devel.i686 
# libnsl

# # gui apps
# xclip
# evince
# synaptic
xpad
# gparted
# moserial
# libncurses* 
# meld
# bustle
# d-feet
# graphviz
# npm
flameshot
# feh
synapse
# latexmk
# baobab
# kernel-devel
# kernel-headers
# pylint
# liveusb-creator
# bleachbit
# gimp

# flatpak
flatpak

# arm toolchain
# openocd
# qemu
# arm-none-eabi-newlib
# arm-none-eabi-gcc-cs 
# arm-none-eabi-gcc-cs-c++

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
    cd /usr/share/user_file/
    
    bash misc/misc_setup.sh
    bash look/look_setup.sh
    bash vscode/vscode_setup.sh
    bash zsh/zsh_setup.sh
    bash flatpak/flatpak_setup.sh
    
    touch ~/first_login_setup_done
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

%end

# %post --nochroot --log=/mnt/sysimage/root/ks-post-no-root.log
# %end
