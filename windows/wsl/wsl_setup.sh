#!/bin/bash
# used for setting up ansible and launch the playbook to setup wsl

software_general_repo_non_gui=" doxygen lm-sensors cmake valgrind gcc clang llvm build-essential htop net-tools minicom screen python3-pip curl libboost-all-dev python3-setuptools ranger tldr silversearcher-ag neofetch autojump dos2unix ansible zsh"

arm_toolchain=" openocd qemu gcc-arm-linux-gnueabi gcc-arm-linux-gnueabihf gdb-multiarch "

currDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ${currDir}
#--------------------------------------------------------------------
# chsh -s /bin/zsh

# sudo apt update && sudo apt dist-upgrade -y && sudo apt install -y ${software_general_repo_non_gui} ${arm_toolchain} && sudo apt autoremove -y

# sudo apt update && sudo apt install ansible -y
ansible-playbook wsl_setup.yml --ask-become-pass
