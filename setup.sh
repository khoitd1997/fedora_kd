set -e

currDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ${currDir}
source ./utils.sh

if [ ! -z "$1" ]; then 
    ansible-playbook ./userland/setup.yml --ask-become-pass --start-at-task="$1"
else 
    ./setup_deps.sh

    ansible-playbook ./userland/setup.yml --ask-become-pass 
fi
