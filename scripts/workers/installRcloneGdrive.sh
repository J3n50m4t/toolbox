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
chown 1000:1000 ~/.config/rclone/rclone.conf 1>/dev/null 2>&1

## Gdrive Part


systemctl stop rcloneGdrive 1>/dev/null 2>&1
systemctl stop rcloneGdriveDecrypt 1>/dev/null 2>&1
systemctl stop rcloneDecrypted 1>/dev/null 2>&1
systemctl stop rclonePlexDrive 1>/dev/null 2>&1
systemctl stop rcloneUploadEncrypted 1>/dev/null 2>&1
systemctl stop plexdrive 1>/dev/null 2>&1

mkdir -p /opt/toolbox/userscripts
mkdir -p $path/rclone/.gdrive
mkdir -p $path/rclone/.gdrive_decrypted
mkdir -p $path/rclone/decrypted
mkdir -p $path/rclone/uploadEncrypted
mkdir -p $path/rclone/unionfs
chown 1000:1000 $path/rclone -R 1>/dev/null 2>&1




###########################################
##Mount GDRIVE
###########################################
tee "/opt/toolbox/userscripts/rcloneGdrive.sh" > /dev/null <<EOF
#!/bin/bash
rclone --uid=1000 --gid=1000 --allow-non-empty --allow-other mount gdrive: $path/rclone/.gdrive --bwlimit 8500k --size-only
EOF

chmod 775 /opt/toolbox/userscripts/rcloneGdrive.sh

tee "/etc/systemd/system/rcloneGdrive.service" > /dev/null <<EOF
[Unit]
Description=RCloneMounting
After=multi-user.target
[Service]
Type=simple
User=0
Group=0
ExecStart=/bin/bash /opt/toolbox/userscripts/rcloneGdrive.sh
ExecStop=/bin/fusermount -uz $path/rclone/.gdrive
TimeoutStopSec=20
KillMode=process
RemainAfterExit=yes
[Install]
WantedBy=multi-user.target
EOF

###########################################
##Decrypt Gdrive and Mount
###########################################
tee "/opt/toolbox/userscripts/rcloneGdriveDecrypt.sh" > /dev/null <<EOF
#!/bin/bash
rclone --uid=1000 --gid=1000 --allow-non-empty --allow-other mount gdrive_decrypted: $path/rclone/.gdrive_decrypted --bwlimit 8500k --size-only
EOF

chmod 775 /opt/toolbox/userscripts/rcloneGdriveDecrypt.sh

tee "/etc/systemd/system/rcloneGdriveDecrypt.service" > /dev/null <<EOF
[Unit]
Description=RCloneMounting
After=multi-user.target
[Service]
Type=simple
User=0
Group=0
ExecStart=/bin/bash /opt/toolbox/userscripts/rcloneGdriveDecrypt.sh
ExecStop=/bin/fusermount -uz $path/rclone/.gdrive_decrypted
TimeoutStopSec=20
KillMode=process
RemainAfterExit=yes
[Install]
WantedBy=multi-user.target
EOF

###########################################
##Decrypt Gdrive and Mount
###########################################
tee "/opt/toolbox/userscripts/rcloneDecrypted.sh" > /dev/null <<EOF
#!/bin/bash
rclone --uid=1000 --gid=1000 --allow-non-empty --allow-other mount decrypted: $path/rclone/decrypted --bwlimit 8500k --size-only
EOF

chmod 775 /opt/toolbox/userscripts/rcloneDecrypted.sh


tee "/etc/systemd/system/rcloneDecrypted.service" > /dev/null <<EOF
[Unit]
Description=RCloneMounting
After=multi-user.target
[Service]
Type=simple
User=0
Group=0
ExecStart=/bin/bash /opt/toolbox/userscripts/rcloneDecrypted.sh
ExecStop=/bin/fusermount -uz $path/rclone/decrypted
TimeoutStopSec=20
KillMode=process
RemainAfterExit=yes
[Install]
WantedBy=multi-user.target
EOF

###########################################
## PlexDrive Mounting
###########################################
tee "/etc/systemd/system/rclonePlexDrive.service" > /dev/null <<EOF
[Unit]
Description=UnionMounting
Requires=plexdrive.service
After=multi-user.target plexdrive.service
RequiresMountsFor= $path/rclone/.plexdrive
[Service]
Type=simple
User=0
Group=0
ExecStartPre=/bin/sleep 10
ExecStart=/usr/bin/unionfs -o cow,allow_other,nonempty $path/rclone/uploadEncrypted=RW:$path/rclone/decrypted=RO $path/rclone/unionfs
ExecStop=/bin/fusermount -uz $path/rclone/unionfs
TimeoutStopSec=20
KillMode=process
RemainAfterExit=yes
[Install]
WantedBy=multi-user.target
EOF

###########################################
## Upload Service Encrypted
###########################################
tee "/opt/toolbox/userscripts/rcloneUploadEncrypted.sh" > /dev/null <<EOF
#!/bin/bash
rclone move --bwlimit 10M --exclude='**.partial~' --exclude="**_HIDDEN~" --exclude=".unionfs/**" --exclude=".unionfs-fuse/**" --log-level INFO $path/rclone/uploadEncrypted gdrive_decrypted:/
sleep 480

find "$path/rclone/uploadEncrypted" -mindepth 2 -type d -empty -delete
done
EOF

chmod 775 /opt/toolbox/userscripts/rcloneUploadEncrypted.sh


tee "/etc/systemd/system/rcloneUploadEncrypted.service" > /dev/null <<EOF
[Unit]
Description=RCloneMounting
After=multi-user.target
[Service]
Type=simple
User=0
Group=0
ExecStart=/bin/bash /opt/toolbox/userscripts/rcloneUploadEncrypted.sh
TimeoutStopSec=20
KillMode=process
RemainAfterExit=yes
[Install]
WantedBy=multi-user.target
EOF


system daemon reload 1>/dev/null 2>&1

systemctl enable rcloneGdrive 1>/dev/null 2>&1
systemctl enable rcloneGdriveDecrypt 1>/dev/null 2>&1
systemctl enable rcloneDecrypted 1>/dev/null 2>&1
systemctl enable rclonePlexDrive 1>/dev/null 2>&1
systemctl enable rcloneUploadEncrypted 1>/dev/null 2>&1


systemctl restart rcloneGdrive 1>/dev/null 2>&1
systemctl restart rcloneGdriveDecrypt 1>/dev/null 2>&1
systemctl restart rcloneDecrypted 1>/dev/null 2>&1
systemctl restart rclonePlexDrive 1>/dev/null 2>&1
systemctl restart rcloneUploadEncrypted 1>/dev/null 2>&1