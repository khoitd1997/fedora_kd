#!/usr/bin/env python3

import os
import subprocess
import sys
import re
import json

abspath = os.path.abspath(__file__)
dname = os.path.dirname(abspath)
os.chdir(dname)

os.environ['ANSIBLE_FORCE_COLOR'] = "True"

ansible_command = ''

setup_storage_file = os.path.join(
    dname, "setup_storage.json")
last_executed_task_key = 'last_executed_task'
last_executed_task = ''

task_name_pattern = re.compile('TASK \\[(.*)\\] ')

if len(sys.argv) > 1:
    arg = sys.argv[1]
    task_name = ''

    if arg == "--continue":
        with open(setup_storage_file,  'r') as f:
            data = json.load(f)
            task_name = data[last_executed_task_key]
    else:
        task_name = arg

    ansible_command = 'ansible-playbook ./userland/setup.yml --ask-become-pass --start-at-task="{0}"'.format(
        task_name)

else:
    os.system('./setup_deps.sh')
    ansible_command = 'ansible-playbook ./userland/setup.yml --ask-become-pass'

p = subprocess.Popen(ansible_command, stdout=subprocess.PIPE,
                     stderr=subprocess.STDOUT, shell=True, universal_newlines=True)

while True:
    line = p.stdout.readline()
    if not line:
        break

    print(line)
    m = task_name_pattern.match(line)
    if m:
        with open(setup_storage_file,  'w') as f:
            json.dump({last_executed_task_key: m.group(1)}, f, indent=4)
