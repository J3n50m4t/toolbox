#!/bin/bash
path=$(cat /opt/toolbox/userconfigs/path)

cd /tmp 
wget https://github.com/dweidenfeld/plexdrive/releases/download/5.0.0/plexdrive-linux-amd64 1>/dev/null 2>&1
mv plexdrive-linux-amd64 /usr/bin/plexdrive 1>/dev/null 2>&1
chmod 755 /usr/bin/plexdrive 1>/dev/null 2>&1
chown 1000:1000 /usr/bin/plexdrive 1>/dev/null 2>&1

mkdir -p $path/rclone/.plexdrive/encrypted 1>/dev/null 2>&1
mkdir -p /var/log/toolbox/ 1>/dev/null 2>&1

###########################################
## Plexdrive mount Script
###########################################
tee "/opt/toolbox/userscripts/plexDrive.sh" > /dev/null <<EOF
plexdrive mount --uid=1000 --gid=1000 -v 3 --refresh-interval=1m --chunk-load-threads=8 --chunk-check-threads=8 --chunk-load-ahead=4 --chunk-size=10M --max-chunks=300 --fuse-options=allow_other,read_only,allow_non_empty_mount --config=/root/.plexdrive --cache-file=/root/.plexdrive/cache.bolt $path/rclone/.plexdrive/ >> /var/log/toolbox/plexDrive.info
EOF

tee "/etc/systemd/system/plexdrive.service" > /dev/null <<EOF
[Unit]
Description=Move Service Daemon
After=multi-user.target network-online.target
[Service]
Type=simple
User=0
Group=0
ExecStart=/bin/bash /opt/toolbox/userscripts/plexDrive.sh
TimeoutStopSec=2
KillMode=process
RemainAfterExit=yes
Restart=always
[Install]
WantedBy=multi-user.target
EOF

system daemon reload 1>/dev/null 2>&1
systemctl enable plexdrive 1>/dev/null 2>&1

plexdrive mount --uid=1000 --gid=1000 -v 3 --refresh-interval=1m --chunk-load-threads=8 --chunk-check-threads=8 --chunk-load-ahead=4 --chunk-size=10M --max-chunks=300 --fuse-options=allow_other,read_only,allow_non_empty_mount --config=/root/.plexdrive --cache-file=/root/.plexdrive/cache.bolt $path/rclone/.plexdrive/