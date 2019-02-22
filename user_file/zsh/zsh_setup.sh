#!/bin/bash
# written for installation of zsh

currDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ${currDir}
source ../utils.sh

zsh_plugin="https://github.com/zsh-users/zsh-completions.git \
            https://github.com/zsh-users/zsh-autosuggestions.git"

#--------------------------------------------------------------------------------------

print_message "Starting zsh installation\n"

# oh-my-zsh stuffs
cd ~
sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"&

cp ${currDir}/.zshrc ~/.zshrc

# plugins
cd ~/.oh-my-zsh/custom/plugins
for plugin in ${zsh_plugin}; do 
git clone ${plugin}
done

print_message "zsh installation done, PLEASE LOG OUT FIRST\n"
