set -e

currDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ${currDir}
source ./utils.sh

function cleanup {	
    rm -f ~/first_login_setup_in_progress	
}	
trap cleanup EXIT
#---------------------------------------------------------

if ! nc -zw1 google.com 443; then                                  	
print_error "\nNetwork not connected please enable network and then press any button to continue\n"	
empty_input_buffer	
read input	
fi

ansible-playbook -v setup.yml --ask-become-pass

touch ~/first_login_setup_done