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
curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -o ~/omz.sh
sed -i '/env zsh/d' ~/omz.sh
sh ~/omz.sh
rm -rf ~/omz.sh

cd ${currDir}
cd ..

ln -vfs ${currDir}/.zshrc ~/.zshrc

# plugins
cd ~/.oh-my-zsh/custom/plugins
for plugin in ${zsh_plugin}; do 
git clone ${plugin}
done

print_message "zsh installation done\n"