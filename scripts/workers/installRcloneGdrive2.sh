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


systemctl stop rcloneGdrive2 1>/dev/null 2>&1
systemctl stop rcloneGdriveDecrypt2 1>/dev/null 2>&1
systemctl stop rcloneDecrypted2 1>/dev/null 2>&1
systemctl stop rclonePlexDrive2 1>/dev/null 2>&1
systemctl stop rcloneUploadEncrypted2 1>/dev/null 2>&1
systemctl stop plexdrive2 1>/dev/null 2>&1

mkdir -p /opt/toolbox/userscripts
mkdir -p $path/rclone2/.gdrive
mkdir -p $path/rclone2/.gdrive_decrypted
mkdir -p $path/rclone2/.plexdrive/encrypted
mkdir -p $path/rclone2/decrypted
mkdir -p $path/rclone2/uploadEncrypted
mkdir -p $path/rclone2/unionfs
chown 1000:1000 $path/rclone2 -R 1>/dev/null 2>&1




###########################################
##Mount GDRIVE
###########################################
tee "/opt/toolbox/userscripts/rcloneGdrive2.sh" > /dev/null <<EOF
#!/bin/bash
rclone --uid=1000 --gid=1000 --allow-non-empty --allow-other mount gdrive2: $path/rclone2/.gdrive --bwlimit 8500k --size-only
EOF

chmod 775 /opt/toolbox/userscripts/rcloneGdrive2.sh

tee "/etc/systemd/system/rcloneGdrive2.service" > /dev/null <<EOF
[Unit]
Description=RCloneMounting
After=multi-user.target
[Service]
Type=simple
User=0
Group=0
ExecStart=/bin/bash /opt/toolbox/userscripts/rcloneGdrive2.sh
ExecStop=/bin/fusermount -uz $path/rclone2/.gdrive
TimeoutStopSec=20
KillMode=process
RemainAfterExit=yes
[Install]
WantedBy=multi-user.target
EOF

###########################################
##Decrypt Gdrive and Mount
###########################################
tee "/opt/toolbox/userscripts/rcloneGdriveDecrypt2.sh" > /dev/null <<EOF
#!/bin/bash
rclone --uid=1000 --gid=1000 --allow-non-empty --allow-other mount gdrive_decrypted2: $path/rclone2/.gdrive_decrypted --bwlimit 8500k --size-only
EOF

chmod 775 /opt/toolbox/userscripts/rcloneGdriveDecrypt2.sh

tee "/etc/systemd/system/rcloneGdriveDecrypt2.service" > /dev/null <<EOF
[Unit]
Description=RCloneMounting
After=multi-user.target
[Service]
Type=simple
User=0
Group=0
ExecStart=/bin/bash /opt/toolbox/userscripts/rcloneGdriveDecrypt2.sh
ExecStop=/bin/fusermount -uz $path/rclone2/.gdrive_decrypted
TimeoutStopSec=20
KillMode=process
RemainAfterExit=yes
[Install]
WantedBy=multi-user.target
EOF

###########################################
##Decrypt Gdrive and Mount
###########################################
tee "/opt/toolbox/userscripts/rcloneDecrypted2.sh" > /dev/null <<EOF
#!/bin/bash
rclone --uid=1000 --gid=1000 --allow-non-empty --allow-other mount decrypted2: $path/rclone2/decrypted --bwlimit 8500k --size-only
EOF

chmod 775 /opt/toolbox/userscripts/rcloneDecrypted2.sh


tee "/etc/systemd/system/rcloneDecrypted2.service" > /dev/null <<EOF
[Unit]
Description=RCloneMounting
After=multi-user.target
[Service]
Type=simple
User=0
Group=0
ExecStart=/bin/bash /opt/toolbox/userscripts/rcloneDecrypted2.sh
ExecStop=/bin/fusermount -uz $path/rclone2/decrypted
TimeoutStopSec=20
KillMode=process
RemainAfterExit=yes
[Install]
WantedBy=multi-user.target
EOF

###########################################
## PlexDrive Mounting
###########################################
tee "/etc/systemd/system/rclonePlexDrive2.service" > /dev/null <<EOF
[Unit]
Description=UnionMounting
Requires=plexdrive2.service
After=multi-user.target plexdrive2.service
RequiresMountsFor= $path/rclone2/.plexdrive
[Service]
Type=simple
User=0
Group=0
ExecStartPre=/bin/sleep 10
ExecStart=/usr/bin/unionfs -o cow,allow_other,nonempty $path/rclone2/uploadEncrypted=RW:$path/rclone2/decrypted=RO $path/rclone2/unionfs
ExecStop=/bin/fusermount -uz $path/rclone2/unionfs
TimeoutStopSec=20
KillMode=process
RemainAfterExit=yes
[Install]
WantedBy=multi-user.target
EOF

###########################################
## Upload Service Encrypted
###########################################
tee "/opt/toolbox/userscripts/rcloneUploadEncrypted2.sh" > /dev/null <<EOF
#!/bin/bash
while true                                                                                                                                                                                                                                                                                                                                                                                   
do 
rclone move --bwlimit 10M --exclude='**.partial~' --exclude="**_HIDDEN~" --exclude=".unionfs/**" --exclude=".unionfs-fuse/**" --log-level INFO $path/rclone2/uploadEncrypted gdrive_decrypted2:/ 1>/var/log/toolbox/uploadEncrypted2 2>&1
sleep 480

find "$path/rclone2/uploadEncrypted" -mindepth 2 -type d -empty -delete
done
EOF

chmod 775 /opt/toolbox/userscripts/rcloneUploadEncrypted2.sh


tee "/etc/systemd/system/rcloneUploadEncrypted2.service" > /dev/null <<EOF
[Unit]
Description=RCloneMounting
After=multi-user.target
[Service]
Type=simple
User=0
Group=0
ExecStart=/bin/bash /opt/toolbox/userscripts/rcloneUploadEncrypted2.sh
TimeoutStopSec=20
KillMode=process
RemainAfterExit=yes
[Install]
WantedBy=multi-user.target
EOF


system daemon reload 1>/dev/null 2>&1

systemctl enable rcloneGdrive2 1>/dev/null 2>&1
systemctl enable rcloneGdriveDecrypt2 1>/dev/null 2>&1
systemctl enable rcloneDecrypted2 1>/dev/null 2>&1
systemctl enable rclonePlexDrive2 1>/dev/null 2>&1
systemctl enable rcloneUploadEncrypted2 1>/dev/null 2>&1


systemctl restart rcloneGdrive2 1>/dev/null 2>&1
systemctl restart rcloneGdriveDecrypt2 1>/dev/null 2>&1
systemctl restart rcloneDecrypted2 1>/dev/null 2>&1
systemctl restart rclonePlexDrive2 1>/dev/null 2>&1
systemctl restart rcloneUploadEncrypted2 1>/dev/null 2>&1
