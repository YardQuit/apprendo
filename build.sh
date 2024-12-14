#!/bin/bash

set -ouex pipefail

RELEASE="$(rpm -E %fedora)"

### checking out /ctx
ls -la /ctx/

### copy systemfiles
rsync -rvK /ctx/system_files/ /

### Install packages
rpm-ostree install $(cat /ctx/packages)

#### Example for enabling a System Unit File
systemctl enable podman.socket
