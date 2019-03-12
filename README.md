# fedora_kd

Khoi Trinh custom fedora config files, including fedora kickstart file for iso build and ansible scripts for userland config on first boot.

## Credits

[OS Logo Made by FreeLogoDesign](1)

Wall paper named [TCP118v1](2) by Tiziano Consonni is licensed under [CC BY-SA 3.0](3)

Base kickstart file comes from the [Fedora Repo](4)

Plymouth animation script borrowed from [Aslan French](5) licensed unsder GPLv3 license

Plymouth animation from [Reddit r/loadingicon](6)

## Dependency

This repo depends on the [fedora kickstart repo](4) used for building popular spins for fedora. By default it should track the latest stable tag of the newest stable fedora branch. The dependency can be initialized using git submodule commands:

```shell
git submodule init
git submodule update
```

## File Organiztion

- ``userland``: folder containing ansible scripts that would set up the os on first login. It sets up a variety of things from vscode to terminal
- ``user_file``: folder containing files to be copied into the iso. It includes things like wallpaper, plymouth theme
- ``fedora-kd``: main kickstart file, relies on base fedora kickstart files from the fedora project
- ``fedora-repo-kd``: auxillary kickstart file that describes the necessary repos during and after build

## How it works

The ``fedora-kd`` file and the ``fedora-repo-kd`` is fed into a mock system to build the base iso. The iso should include personal packages on top of regular packages of the fedora cinnamon spin. The kickstart file also configures so that the first time a user logs in, it clone this repo to their home directory and start the ansible installation in the ``userland`` folder, the ansible script will configure things not easily done during the mock build, if the installation went well, the user should get a functioning system and the ansible script won't have to be run again.

The ansible script is mostly composed of tasks described by yml in their separate directory, however, scripts in other languages are occassionally used such as in the case of vscode to make sure that even when it's hard to run ansible(such as on windows), the installation can still be run manually, scripts are also used when it makes more sense to use them(such as when using python to manipulate json files)

[1]: https://www.freelogodesign.org/
[2]: https://www.ostechnix.com/default-set-wallpapers-ubuntu-16-04-lts
[3]: https://creativecommons.org/licenses/by-sa/3.0/us/
[4]: https://pagure.io/fedora-kickstarts
[5]: https://github.com/jcklpe/Plymouth-Animated-Boot-Screen-Creator
[6]: https://www.reddit.com/r/loadingicon/comments/6hy8cd/when_loading_takes_forever_oc/