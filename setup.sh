set -e

currDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ${currDir}
source ./utils.sh

./setup_deps.sh

if [ -z "$INSIDE_CI" ]; then
    ansible-playbook ./userland/setup.yml --ask-become-pass 
else
    ansible-playbook ./userland/setup.yml -b --skip-tags "no_ci"
fi