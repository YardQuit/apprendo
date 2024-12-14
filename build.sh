#!/bin/bash

set -ouex pipefail

RELEASE="$(rpm -E %fedora)"

### Install packages
rpm-ostree install $(cat /tmp/packages_personal)
rpm-ostree install $(cat /tmp/packages_security)

#### Example for enabling a System Unit File
systemctl enable podman.socket
