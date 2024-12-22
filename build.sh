#!/bin/bash

set -ouex pipefail

RELEASE="$(rpm -E %fedora)"

### Copy pre-configured system files
rsync -rvK /tmp/system_files/ /

### Create system directory structues
mkdir -p /var/lib/alternatives

### Enable fstrim for encrypted drives
cp /etc/crypttab /etc/crypttab.bak
sed -i 's/none$/none discard/g' /etc/crypttab

### Install repository package(s)
dnf install \
$(cat /tmp/packages/desktop) \
$(cat /tmp/packages/develop) \
$(cat /tmp/packages/fonts) \
$(cat /tmp/packages/multimedia) \
$(cat /tmp/packages/personal) \
$(cat /tmp/packages/security) \
$(cat /tmp/packages/temporary) \
$(cat /tmp/packages/virtual)

### Install language servers with Node Package Manager
npm -y --global install $(cat /tmp/packages/nodepackages)

### Disabling System Unit File(s)
systemctl disable cosmic-greeter.service

### Enabling System Unit File(s)
systemctl enable rpm-ostreed-automatic.timer
systemctl enable tuned.service
systemctl enable docker.service
systemctl enable podman.socket
systemctl enable fstrim.timer

### Enable virtualization Unit File(s)
for drv in qemu interface network nodedev nwfilter secret storage; do
    systemctl enable virt${drv}d.service;
    systemctl enable virt${drv}d{,-ro,-admin}.socket;
done

### Enable nested virtualization
echo 'options kvm_intel nested=1' > /etc/modprobe.d/kvm_intel.conf

### Change default firewalld zone
cp /etc/firewalld/firewalld-workstation.conf /etc/firewalld/firewalld-workstation.conf.bak
sed -i 's/DefaultZone=FedoraWorkstation/DefaultZone=drop/g' /etc/firewalld/firewalld-workstation.conf


###############################################################################
# START - ONLY FOR MY PERSONAL USE
###############################################################################

### Add yubico challange for sudo (DISABLED)
# cp /etc/pam.d/sudo /etc/pam.d/sudo.bak
# sed -i '/PAM-1.0/a\auth       required     pam_yubico.so mode=challenge-response' /etc/pam.d/sudo

### (VERY PERSONAL) Add encrypted drives to crypttab
# sudo tee -a /etc/crypttab <<EOF
# # manually added
# luks-bccaf371-16c7-45fd-9b1a-1dc540d37218 UUID=bccaf371-16c7-45fd-9b1a-1dc540d37218 none discard
# luks-4d1fa180-514b-4b2f-b028-4fbd80714ba0 UUID=4d1fa180-514b-4b2f-b028-4fbd80714ba0 none discard
# luks-f4ba7b65-7a97-4661-9d37-333d0fc12582 UUID=f4ba7b65-7a97-4661-9d37-333d0fc12582 none discard
# EOF

# (VERY PERSONAL) Update fstab with encrypted drives
# sudo cp /etc/fstab /etc/fstab.bak
# sudo sed -i '\/home /d' /etc/fstab
# sudo tee -a /etc/fstab <<EOF
# UUID=a1f3db46-7cbc-4fe7-8940-da1238319914 	/home             btrfs   subvol=home,compress=zstd:1,x-systemd.device-timeout=0 0 0
# UUID=d459a275-73d7-48a0-bcb2-b6b3272635e6 	/mnt/fstab_virt   ext4    defaults,x-systemd.device-timeout=0 1 2
# UUID=2a8f21d0-de05-48dc-bf5b-6487504c4c07 	/mnt/fstab_stash  ext4    defaults,x-systemd.device-timeout=0 1 2
# EOF

###############################################################################
# END - ONLY FOR MY PERSONAL USE
###############################################################################


### Clean Up
shopt -s extglob
rm -rf /tmp/* || true
rm -rf /var/!(cache)
rm -rf /var/cache/!(rpm-ostree)
rm -rf /etc/yum.repos.d/1password.repo
rm -rf /etc/yum.repos.d/_copr:copr.fedorainfracloud.org:gmaglione:podman-bootc.repo
rm -rf /etc/yum.repos.d/_copr:copr.fedorainfracloud.org:pennbauman:ports.repo
rm -rf /etc/yum.repos.d/_copr_ryanabx-cosmic.repo
rm -rf /etc/yum.repos.d/atim-starship-fedora-41.repo
rm -rf /etc/yum.repos.d/fedorapeople.org.groups.virt.virtio-win.virtio-win.repo
