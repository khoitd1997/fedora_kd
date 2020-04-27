#!/usr/bin/env python3

from wasabi import Printer
import os
import json


script_dir = os.path.dirname(__file__)
storage_file_path = os.path.join(script_dir, "tool_reminder_storage.json")

tools_to_remind = [
    "glances: system monitoring tool",
    "tldr: more concise man page",
    "fzf ctrl-T: quickly find folders and files",
    "exa: ls replacement",
    "tig: command line git repo browser",
    "peco: command line filter gui",
    "heaptrack: informative gui memory profiler",
    "tree: display directory structure",
]
tools_per_print = min(3, len(tools_to_remind))

msg = Printer()

curr_index = 0
try:
    with open(storage_file_path) as json_file:
        data = json.load(json_file)
        curr_index = data['curr_index']
except FileNotFoundError:
    pass

msg.warn("tooling")
for x in range(0, tools_per_print):
    curr_index = (curr_index + 1) % len(tools_to_remind)
    curr = tools_to_remind[curr_index]
    msg.info(curr)

with open(storage_file_path, 'w') as outfile:
    json.dump({
        'curr_index': curr_index
    }, outfile)
