# fedora_kd

Khoi Trinh custom fedora config files

## How to use

On a fresh fedora installation, run ```setup.sh```

## Testing the ansible script

```vagrant``` is used to bring up a VM to test the ansible script. The default vscode build task calls the ```vagrant_test.sh``` to do that

Some useful commands:

```shell
vagrant ssh # helpful for ssh into the VM
vagrant destroy -f # destroy the current VM
vagrant up --provider=libvirt # bring up the VM
vagrant reload # restart the vm and update some configs

ansible-playbook userland/setup.yml --start-at-task="task_name" # good for continuing the playbook after fixing errors
```

There is a vscode build target that launch a vnc viewer to look into the VM

NOTE: vagrant can have virtualbox as provider and has UI but not sure if worth it since it's pretty clunky and there are a couple of problems with dependency conflict when installing the vagrant guest addition plugin

## Credits

[OS Logo Made by FreeLogoDesign][1]

Wall paper named [TCP118v1][2] by Tiziano Consonni is licensed under [CC BY-SA 3.0][3]

Base kickstart file comes from the [Fedora Repo][4]

Plymouth animation script borrowed from [Aslan French][5] licensed unsder GPLv3 license

Plymouth animation from [Reddit r/loadingicon][6]

### Awesomewm

[Awesomewm config heaviliy based on Elena's github][7]

[Awesome calendar][8]

[Awesome autofocus][9]

### Kickstart Files

[1]: https://www.freelogodesign.org/
[2]: https://www.ostechnix.com/default-set-wallpapers-ubuntu-16-04-lts
[3]: https://creativecommons.org/licenses/by-sa/3.0/us/
[4]: https://pagure.io/fedora-kickstarts
[5]: https://github.com/jcklpe/Plymouth-Animated-Boot-Screen-Creator
[6]: https://www.reddit.com/r/loadingicon/comments/6hy8cd/when_loading_takes_forever_oc/
[7]: https://github.com/elenapan/dotfiles
[8]: https://github.com/deficient/calendar
[9]: https://github.com/awesomeWM/awesome/blob/master/lib/awful/autofocus.lua
