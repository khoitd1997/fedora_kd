# third party
repo --name=google-chrome --baseurl=http://dl.google.com/linux/chrome/rpm/stable/x86_64 --install

repo --name=code --baseurl=https://packages.microsoft.com/yumrepos/vscode --install

# rpm fusion
repo --name=rpmfusion-free-updates --install --metalink=https://mirrors.rpmfusion.org/metalink?repo=free-fedora-updates-released-$releasever&arch=$basearch
repo --name=rpmfusion-free --install --metalink=https://mirrors.rpmfusion.org/metalink?repo=free-fedora-$releasever&arch=$basearch

repo --name=rpmfusion-nonfree-updates --install --metalink=https://mirrors.rpmfusion.org/metalink?repo=nonfree-fedora-updates-released-$releasever&arch=$basearch

repo --name=rpmfusion-nonfree --install --metalink=https://mirrors.rpmfusion.org/metalink?repo=nonfree-fedora-$releasever&arch=$basearch

repo --name=rpmfusion-nonfree-nvidia-driver --metalink=https://mirrors.rpmfusion.org/metalink?repo=nonfree-fedora-nvidia-driver-$releasever&arch=$basearch --install

# modular
repo --name=fedora-modular --install --metalink=https://mirrors.fedoraproject.org/metalink?repo=fedora-modular-$releasever&arch=$basearch
repo --name=updates-modular --install --metalink=https://mirrors.fedoraproject.org/metalink?repo=updates-released-modular-f$releasever&arch=$basearch