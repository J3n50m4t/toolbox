#!/bin/bash

path=$(cat /opt/toolbox/userconfigs/path)

# Install Rclone
## as seen here https://rclone.org/install/#linux-installation-from-precompiled-binary
cd /tmp
curl -O https://downloads.rclone.org/rclone-current-linux-amd64.zip 1>/dev/null 2>&1
unzip rclone-current-linux-amd64.zip 1>/dev/null 2>&1
cd rclone-*-linux-amd64
cp rclone /usr/bin/ 1>/dev/null 2>&1
chown 1000:1000 /usr/bin/rclone 1>/dev/null 2>&1
chmod 775 /usr/bin/rclone 1>/dev/null 2>&1
sudo mkdir -p /usr/local/share/man/ 1>/dev/null 2>&1
sudo cp rclone.1 /usr/local/share/man/man1/
sudo mandb 1>/dev/null 2>&1
cd /tmp
sudo rm -r rclone* 1>/dev/null 2>&1
cd ~
clear
rclone config

tee "/etc/fuse.conf" > /dev/null <<EOF
  # /etc/fuse.conf - Configuration file for Filesystem in Userspace (FUSE)
  # Set the maximum number of FUSE mounts allowed to non-root users.
  # The default is 1000.
  #mount_max = 1000
  # Allow non-root users to specify the allow_other or allow_root mount options.
  user_allow_other
EOF

mkdir -p /root/.config/rclone/ 1>/dev/null 2>&1
cp ~/.config/rclone/rclone.conf /root/.config/rclone/ 1>/dev/null 2>&1

## Gdrive Part

mkdir -p $path/rclone/.gdrive
mkdir -p $path/rclone/.gdrive_decrypted
mkdir -p $path/rclone/decrypted

#wip . nt 