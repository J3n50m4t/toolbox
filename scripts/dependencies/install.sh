#!/bin/bash

#installing
## docker
## ansible

echo "0" | dialog --gauge "Installing docker" 10 70 0
sudo apt-get install docker docker.io -y 1>/dev/null 2>&1
echo "50" | dialog --gauge "Installing ansible" 10 70 0
sudo apt-get install ansible -y 1>/dev/null 2>&1
echo "100" | dialog --gauge "Everything installed successfuly, going back to main menu" 10 70 0
sleep 2
sudo bash /opt/toolbox/menu.sh
