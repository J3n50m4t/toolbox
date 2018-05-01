#!/bin/bash

#installing
## docker
## ansible

echo "0" | dialog --gauge "Installing docker" 10 70 0
sudo apt-get install docker docker.io -y 1>/dev/null 2>&1
echo "14" | dialog --gauge "Installing ansible" 10 70 0
sudo apt-get install ansible -y 1>/dev/null 2>&1
echo "28" | dialog --gauge "Installing python" 10 70 0
sudo apt-get install python-pip -y 1>/dev/null 2>&1
echo "42" | dialog --gauge "Installing docker-py" 10 70 0
sudo pip install docker-py 1>/dev/null 2>&1

echo "56" |  dialog --gauge "Installing portainer" 10 70 0
ansible-playbook /opt/toolbox/ansiblescripts/toolbox.yml --tags network &>/dev/null &
echo "70" | dialog --gauge "Installing ansible" 10 70 0
ansible-playbook /opt/toolbox/ansiblescripts/toolbox.yml --tags portainer &>/dev/null &
echo "75" |  dialog --gauge "Installing traefik" 10 70 0
echo "100" | dialog --gauge "Everything installed successfuly, going back to main menu" 10 70 0
sleep 2
sudo bash /opt/toolbox/menu.sh
