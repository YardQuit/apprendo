# Purpose

This repository is meant to be a quick setup and restore for my personal use.

# Install

To rebase from an atomic distribution:
```bash
sudo bootc switch --enforce-container-sigpolicy ghcr.io/yardquit/atomic_custm:latest
```

# Post Install
This image need YubiKey to enter sudo. To register a YubiKey:
```bash
ykpamcfg -2
```

To install fapolicyd:
```bash
rpm-ostree install fapolicyd fapolicyd-selinux rpm-plugin-fapolicyd

reboot

sudo systemctl enable --now fapolicyd.service
```
