#!/bin/bash

set -ouex pipefail

RELEASE="$(rpm -E %fedora)"

### Install packages
rpm-ostree install \
$(cat /tmp/packages_desktop) \
$(cat /tmp/packages_develop) \
$(cat /tmp/packages_fonts) \
$(cat /tmp/packages_multimedia) \
$(cat /tmp/packages_personal) \
$(cat /tmp/packages_security) \
$(cat /tmp/packages_temporary) \
$(cat /tmp/packages_virtual)

### Run configuration scripts
sh /tmp/kvm.sh
sh /tmp/yubico.sh

### Enabling System Unit File(s)
systemctl enable rpm-ostreed-automatic.timer
systemctl enable fail2ban.service
systemctl enable tuned.service
systemctl enable docker.service
systemctl enable podman.socket
systemctl enable fstrim.timer

### Disabling System Unit File(s)
systemctl disable cosmic-greeter.service
