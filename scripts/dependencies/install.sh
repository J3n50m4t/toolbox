#!/bin/bash

echo "0" | dialog --gauge "Updating repo" 10 70 0
sudo apt-get update
echo "10" | dialog --gauge "Installing docker" 10 70 0
sudo apt-get install docker docker.io -y 1>/dev/null 2>&1
echo "20" | dialog --gauge "Installing ansible" 10 70 0
sudo apt-get install ansible -y 1>/dev/null 2>&1
echo "30" | dialog --gauge "Installing Unzip" 10 70 0
sudo apt-get install unzip -y 1>/dev/null 2>&1
echo "40" | dialog --gauge "Installing curl" 10 70 0
sudo apt-get install curl -y 1>/dev/null 2>&1
echo "50" | dialog --gauge "Installing wget" 10 70 0
sudo apt-get install wget -y 1>/dev/null 2>&1
echo "60" | dialog --gauge "Installing unionfs-fuse" 10 70 0
sudo apt-get install unionfs-fuse -y 1>/dev/null 2>&1
echo "70" | dialog --gauge "Installing python-pip" 10 70 0
sudo apt-get install python-pip -y 1>/dev/null 2>&1
echo "80" | dialog --gauge "Installing docker-py" 10 70 0
sudo pip install docker-py 1>/dev/null 2>&1
echo "90" | dialog --gauge "Setting up docker and installing Portainer" 10 70 0
ansible-playbook /opt/toolbox/ansiblescripts/toolbox.yml --tags network &>/dev/null &
ansible-playbook /opt/toolbox/ansiblescripts/toolbox.yml --tags portainer &>/dev/null &
ansible-playbook /opt/toolbox/ansiblescripts/toolbox.yml --tags dockerrestart &>/dev/null &
echo "100" | dialog --gauge "Everything installed successfuly, going back to main menu" 10 70 0
sleep 2
sudo bash /opt/toolbox/menu.sh