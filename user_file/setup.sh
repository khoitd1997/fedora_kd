#!/bin/bash
source utils.sh
set -e
#---------------------------------------------------------------------

mkdir -p ~/first_login_log
print_message "Starting First Login Setup\n"

print_section "Configuring Miscellaneous Items"
bash misc/misc_setup.sh 2>&1 | tee -a ~/first_login_log/misc_log.log

print_section "Configuring Vscode"
bash vscode/vscode_setup.sh 2>&1 | tee -a ~/first_login_log/vscode_log.log

print_section "Configuring Zsh"
bash zsh/zsh_setup.sh 2>&1 | tee -a ~/first_login_log/zsh_log.log

print_section "Configuring Flatpak"
bash flatpak/flatpak_setup.sh 2>&1 | tee -a ~/first_login_log/flatpak_log.log

print_section "Configuring Look"
bash look/look_setup.sh 2>&1 | tee -a ~/first_login_log/look_log.log

touch ~/first_login_setup_done
print_message "First Login Setup Done\n"