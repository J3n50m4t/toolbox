echo "install git ca-certificates sudo"
apt-get install git ca-certificates sudo -y > /dev/null 2>&1
echo "creating directory /opt/toolbox and setting rights"
sudo mkdir -p /opt/toolbox > /dev/null 2>&1
sudo chown 1000:1000 /opt/toolbox > /dev/null 2>&1
sudo chmod 750 /opt/toolbox > /dev/null 2>&1
echo "cloning toolbox"
git clone https://github.com/J3n50m4t/toolbox.git /opt/toolbox > /dev/null 2>&1
sudo chmod 750 /opt/toolbox -R > /dev/null 2>&1
echo "creating subdirs"
mkdir -p /opt/toolbox/userconfigs > /dev/null 2>&1
sudo cp /opt/toolbox/toolbox /bin > /dev/null 2>&1
sudo chmod 755 /bin/toolbox > /dev/null 2>&1
echo "run toolbox by typing 'toolbox' into your terminal"
