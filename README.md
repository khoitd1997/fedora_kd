# fedora_kd

Khoi Trinh custom fedora config files, including fedora kickstart file for iso build and ansible scripts for userland config on first boot.

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

## Dependency

This repo depends on the [fedora kickstart repo][4] used for building popular spins for fedora. When a new stable version is released, the tag is manually adjusted to track the new version. The dependency can be initialized using git submodule commands:

```shell
git submodule init
git submodule update
```

## File Organiztion

The repos contain the files necessary for first time setup as well as kickstart files to build a variety of desktop environment.

### Folders

- `userland`: folder containing ansible scripts that would set up the os on first login. It sets up a variety of things from vscode to terminal
- `user_file`: folder containing files to be copied into the iso. It includes things like wallpaper, plymouth theme

### Kickstart Files

- `fedora-kd-i3`: kickstart file an i3 based distro
- `fedora-kd-awesome`: kickstart file an awesome based distro
- `fedora-kd-cinnamon`: kickstart file an cinnamon based distro
- `fedora-kd-hybrid`: a kickstart file for a hybrid build that uses both cinnamon and awesome, the reason is to always have a backup desktop environment in case the main one fails

- `fedora-kd-base`: base kickstart files containing packages and installation steps that all distro needs
- `fedora-kd-non-main-de.ks`: contain software and installation for builds that don't originate from major desktop environment like kde, gnome, cinnamon, etc
- `fedora-repo-kd`: auxillary kickstart file that describes the necessary repos during and after build

## How it works

Let's say we want to build the `fedora-kd-hybrid` one.

The `fedora-kd-hybrid` file and its dependencies are fed into a mock system to build the base iso. The iso should include personal packages on top of regular packages that come with default fedora. The kickstart file also configures so that the first time a user logs in, it clone this repo to their home directory and start the ansible installation in the `userland` folder, the ansible script will configure things not easily done during the mock build, if the installation went well, the user should get a functioning system and the ansible script won't have to be run again. The scripts create files to mark progress such as `~/.first_login_setup_done` and use them to check whether to build or not.

The ansible script is mostly composed of tasks described by yml in their separate directory, however, scripts in other languages are occassionally used such as in the case of vscode to make sure that even when it's hard to run ansible(such as on windows), the installation can still be run manually, scripts are also used when it makes more sense to use them(such as when using python to manipulate json files)

[1]: https://www.freelogodesign.org/
[2]: https://www.ostechnix.com/default-set-wallpapers-ubuntu-16-04-lts
[3]: https://creativecommons.org/licenses/by-sa/3.0/us/
[4]: https://pagure.io/fedora-kickstarts
[5]: https://github.com/jcklpe/Plymouth-Animated-Boot-Screen-Creator
[6]: https://www.reddit.com/r/loadingicon/comments/6hy8cd/when_loading_takes_forever_oc/
[7]: https://github.com/elenapan/dotfiles
[8]: https://github.com/deficient/calendar
[9]: https://github.com/awesomeWM/awesome/blob/master/lib/awful/autofocus.lua
