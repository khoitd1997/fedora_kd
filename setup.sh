set -e

currDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ${currDir}
source ./utils.sh

#---------------------------------------------------------

if ! nc -zw1 google.com 443; then                                  	
print_error "\nNetwork not connected please enable network and then press any button to continue\n"	
empty_input_buffer	
read input	
fi

if [ -z "$INSIDE_CI" ]; then
    ansible-playbook ./userland/setup.yml --ask-become-pass 
else
    ansible-playbook ./userland/setup.yml -b
fi