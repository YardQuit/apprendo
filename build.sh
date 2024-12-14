#!/bin/bash

set -ouex pipefail

RELEASE="$(rpm -E %fedora)"

### Add repositories
# ryanabx COSMIC DE repositoy
curl --retry 3 -Lo /etc/yum.repos.d/_copr_ryanabx-cosmic.repo \
    https://copr.fedorainfracloud.org/coprs/ryanabx/cosmic-epoch/repo/fedora-$(rpm -E %fedora)/ryanabx-cosmic-epoch-fedora-$(rpm -E %fedora).repo

# atim STARSHIP repository
curl --retry 3 -Lo /etc/yum.repos.d/atim-starship-fedora.repo \
    https://copr.fedorainfracloud.org/coprs/atim/starship/repo/fedora-%OS_VERSION%/atim-starship-fedora-%OS_VERSION%.repo

# virt VIRTIO-WIN repository
curl --retry 3 -Lo /etc/yum.repos.d/fedorapeople.org.groups.virt.virtio-win.virtio-win.repo \
    https://fedorapeople.org/groups/virt/virtio-win/virtio-win.repo

# pennbauman LF, Zellij repository
sh -c 'echo -e "[1password]\nname=1Password Stable Channel\nbaseurl=https://downloads.1password.com/linux/rpm/stable/\$basearch\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=https://downloads.1password.com/linux/keys/1password.asc" > /etc/yum.repos.d/1password.repo'

# gmaglione PODMAN-BOOTC repository
sh -c 'echo -e "[copr:copr.fedorainfracloud.org:gmaglione:podman-bootc]\nname=Copr repo for podman-bootc owned by gmaglione\nbaseurl=https://download.copr.fedorainfracloud.org/results/gmaglione/podman-bootc/fedora-\$releasever-\$basearch/\ntype=rpm-md\nskip_if_unavailable=True\ngpgcheck=1\ngpgkey=https://download.copr.fedorainfracloud.org/results/gmaglione/podman-bootc/pubkey.gpg\nrepo_gpgcheck=0\nenabled=1\nenabled_metadata=1" > /etc/yum.repos.d/_copr\:copr.fedorainfracloud.org\:gmaglione\:podman-bootc.repo'


### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1

# this installs a package from fedora repos
rpm-ostree install lf starship 1password

# this would install a package from rpmfusion
# rpm-ostree install vlc

#### Example for enabling a System Unit File

systemctl enable podman.socket
