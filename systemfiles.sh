#!/bin/bash

set -ouex pipefail
# Make Alternatives Directory
mkdir -p /var/lib/alternatives

### Add system files
rsync -rvK /ctx/system_files/ /

# Clean Up
mv /var/lib/alternatives /staged-alternatives
/ctx/build_files/shared/clean-stage.sh
mkdir -p /var/lib && mv /staged-alternatives /var/lib/alternatives && \
mkdir -p /var/tmp && \
chmod -R 1777 /var/tmp
ostree container commit
