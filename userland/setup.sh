set -e

currDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ${currDir}
source ./utils.sh

function cleanup {	
    rm -f ~/first_login_setup_in_progress	
}	
trap cleanup EXIT

skip_tags=""
function select_skip_tags {
for de in cinnamon i3 awesome
do
    if [ "${DESKTOP_SESSION}" != "${de}" ]; then
        if [ -z "$skip_tags" ]
        then
            skip_tags="${de}"
        else
            skip_tags="${skip_tags},${de}"
        fi
    fi
done
}

#---------------------------------------------------------

if ! nc -zw1 google.com 443; then                                  	
print_error "\nNetwork not connected please enable network and then press any button to continue\n"	
empty_input_buffer	
read input	
fi

select_skip_tags
# ansible-playbook setup.yml --ask-become-pass --skip-tags "${skip_tags}"
ansible-playbook setup.yml --ask-become-pass 

touch ~/first_login_setup_done