sudo apt-get install git -y
sudo mkdir /opt/toolbox
sudo chown 1000:1000 /opt/toolbox
sudo chmod 750 /opt/toolbox
git clone git@github.com:J3n50m4t/toolbox.git /opt/toolbox
sudo chmod 750 /opt/toolbox -R
mkdir /opt/toolbox/userconfigs
cp /opt/toolbox/toolbox /bin
chmod 755 /bin/toolbox
echo "run toolbox by typing 'toolbox' into your terminal"
