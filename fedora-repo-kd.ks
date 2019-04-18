%include fedora-kickstarts/fedora-repo-not-rawhide.ks

# rpm fusion
repo --name=rpmfusion-free-updates --metalink=https://mirrors.rpmfusion.org/metalink?repo=free-fedora-updates-released-$releasever&arch=$basearch --cost=50
repo --name=rpmfusion-free --metalink=https://mirrors.rpmfusion.org/metalink?repo=free-fedora-$releasever&arch=$basearch --cost=50

repo --name=rpmfusion-nonfree-updates --metalink=https://mirrors.rpmfusion.org/metalink?repo=nonfree-fedora-updates-released-$releasever&arch=$basearch --cost=50

repo --name=rpmfusion-nonfree  --metalink=https://mirrors.rpmfusion.org/metalink?repo=nonfree-fedora-$releasever&arch=$basearch --cost=50

# modular
repo --name=fedora-modular --metalink=https://mirrors.fedoraproject.org/metalink?repo=fedora-modular-$releasever&arch=$basearch --cost=50
repo --name=updates-modular --metalink=https://mirrors.fedoraproject.org/metalink?repo=updates-released-modular-f$releasever&arch=$basearch --cost=50

# repo --name=package_cache --baseurl=file:///package_cache --cost=5
