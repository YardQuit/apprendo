#!/bin/bash

set -ouex pipefail

RELEASE="$(rpm -E %fedora)"

### checking out /ctx
ls -la /ctx/

### Install packages
rpm-ostree install $(cat /ctx/packages)

#### Example for enabling a System Unit File
systemctl enable podman.socket
