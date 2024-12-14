#!/bin/bash

set -ouex pipefail

RELEASE="$(rpm -E %fedora)"

### Install packages
rpm-ostree install $(cat /tmp/packages)

#### Example for enabling a System Unit File
systemctl enable podman.socket
