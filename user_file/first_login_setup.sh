#!/bin/bash

mkdir -p ~/first_login_log

bash look/look_setup.sh 2>&1 | tee -a ~/first_login_log/look_log.log
# bash vscode/vscode_setup.sh | tee -a ~/first_login_log/vscode_log.log
# bash zsh/zsh_setup.sh | tee -a ~/first_login_log/zsh_log.log
# bash flatpak/flatpak_setup.sh | tee -a ~/first_login_log/flatpak_log.log
# bash misc/misc_setup.sh 2>&1 | tee -a ~/first_login_log/misc_log.log