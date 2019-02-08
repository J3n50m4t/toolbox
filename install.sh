echo "install git ca-certificates sudo"
apt-get install git ca-certificates sudo -y > /dev/null 2>&1
sudo mkdir -p /opt/toolbox
sudo chown 1000:1000 /opt/toolbox
sudo chmod 750 /opt/toolbox
git clone https://github.com/J3n50m4t/toolbox.git /opt/toolbox
sudo chmod 750 /opt/toolbox -R
mkdir -p /opt/toolbox/userconfigs
sudo cp /opt/toolbox/toolbox /bin
sudo chmod 755 /bin/toolbox
echo "run toolbox by typing 'toolbox' into your terminal"
