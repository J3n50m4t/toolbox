#!/bin/bash
path=$(cat /opt/toolbox/userconfigs/path)
sudo mkdir -p $path
sudo chmod 750 $path
sudo chown 1000:1000 $path
