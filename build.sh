#!/bin/bash

set -ouex pipefail

RELEASE="$(rpm -E %fedora)"

### Install packages
rpm-ostree install $(cat /tmp/packages_desktop)
rpm-ostree install $(cat /tmp/packages_develop)
rpm-ostree install $(cat /tmp/packages_fonts)
rpm-ostree install $(cat /tmp/packages_multimedia)
rpm-ostree install $(cat /tmp/packages_personal)
rpm-ostree install $(cat /tmp/packages_security)
rpm-ostree install $(cat /tmp/packages_temporary)
rpm-ostree install $(cat /tmp/packages_virtual)

### Run configuration scripts
sh /tmp/kvm.sh
sh /tmp/yubico.sh

### Example for enabling a System Unit File
systemctl enable rpm-ostreed-automatic.timer
systemctl enable fail2ban.service
systemctl enable tuned.service
systemctl enable docker.service
systemctl enable podman.socket
systemctl enable fstrim.timer

systemctl disable cosmic-greeter.service
