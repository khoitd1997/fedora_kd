set -e

currDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ${currDir}
source ./utils.sh

./setup_deps.sh

ansible-playbook ./userland/setup.yml --ask-become-pass 