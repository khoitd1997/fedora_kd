#!/bin/bash
source utils.sh
set -e
function cleanup {
    rm -f ~/first_login_setup_in_progress
}
trap cleanup EXIT
#---------------------------------------------------------------------

mkdir -p ~/first_login_log

# source: 
# https://unix.stackexchange.com/questions/190513/shell-scripting-proper-way-to-check-for-internet-connectivity
if ! nc -zw1 google.com 443; then                                  
print_error "\nNetwork not connected please enable network and then press any button to continue\n"
empty_input_buffer
read input
fi

print_message "Starting First Login Setup, Please Be Ready to Enter Sudo Password, this will take about 20 minutes\n"

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
rm -f ~/first_login_setup_in_progress
print_message "First Login Setup Done, You Should Restart Your Computer\n"