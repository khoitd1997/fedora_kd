#!/usr/bin/env python3

from typing import List
import wasabi
import os
import json


def print_reminders(tools: List[dict]) -> None:
    storage_data = {}

    try:
        script_dir = os.path.dirname(__file__)
        storage_file_path = os.path.join(
            script_dir, "tool_reminder_storage.json")

        with open(storage_file_path, 'r') as json_file:
            storage_data = json.load(json_file)
    except FileNotFoundError:
        pass

    printer = wasabi.Printer()

    for tool in tools:
        tool_name = tool['name']
        tool_list = tool['list']
        storage_key = 'curr {0} index'.format(tool_name)
        curr_index = storage_data.get(storage_key, 0)
        tools_per_print = min(3, len(tool_list))

        printer.warn(tool_name)  # use warn because of the color
        for x in range(0, tools_per_print):
            printer.info(tool_list[curr_index])
            curr_index = (curr_index + 1) % len(tool_list)
        if tool != tools[-1]:
            print()

        storage_data[storage_key] = curr_index

    with open(storage_file_path, 'w') as outfile:
        json.dump(storage_data, outfile)


cmdline_tools = {
    'name': "cmdline tools",
    'list': ["glances: system monitoring tool",
             "tldr: more concise man page",
             "fzf ctrl-T: quickly find folders and files",
             "z: navigate regularly-used directory",
             "tig: command line git repo browser",
             "peco: command line filter gui",
             "heaptrack: informative gui memory profiler",
             "ssh-copy-id: copy key to remote server",
             "tree: display directory structure",
             "Terminal Ctrl-W: Delete current word",
             "Terminal Ctrl-Y: Paste back word just deleted",
             "Terminal Ctrl-D: Log out",
             ]
}

vscode_extension = {
    'name': "vscode extensions",
    'list': [
        "partial diff: diff partial section",
        "file utils: convenient file operations",
        "fold plus: smarter folding",
        "remote development: use vscode through ssh",
        "F11: fullscreen",
        "Ctrl+K: look around without moving cursors",
    ]
}

print_reminders([cmdline_tools, vscode_extension])
