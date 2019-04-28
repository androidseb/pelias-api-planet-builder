#!/bin/bash

# The purpose of this script is to install the pelias service builder on the
# current machine. Note that this script should be run as root.

# Exit on any error encountered
set -e

# Run the config file to import the configured variables
sh ./config.sh

################################################################################
# Step 1: install base dependencies
################################################################################
apt-get update -qq
apt-get install -y nginx


################################################################################
# Step 2: install vagrant + dependencies
################################################################################

# Install vagrant
sh ./install_vagrant.sh


################################################################################
# Step 3: create the dedicated pelias user and setup files in their home folder
################################################################################

# Create a dedicated pelias user
useradd -d $USERHOME -s /bin/bash -m $USERNAME
usermod -G vboxusers $USERNAME
chmod a+x $USERHOME

# Copy the vagrant files into the newly created user's home folder
cp -r ./pelias_vm_builder $USERHOME/
chown -R $USERNAME $USERHOME


################################################################################
# Step 4: configure nginx to redirect incoming https traffic to localhost:4000
################################################################################

echo "server {">/etc/nginx/sites-enabled/$SERVER_DOMAIN_NAME
echo "  server_name $SERVER_DOMAIN_NAME;">>/etc/nginx/sites-enabled/$SERVER_DOMAIN_NAME
echo "  location / {">>/etc/nginx/sites-enabled/$SERVER_DOMAIN_NAME
echo "    proxy_pass http://localhost:4000;">>/etc/nginx/sites-enabled/$SERVER_DOMAIN_NAME
echo "    proxy_set_header X-Real-IP \$remote_addr;">>/etc/nginx/sites-enabled/$SERVER_DOMAIN_NAME
echo "  }">>/etc/nginx/sites-enabled/$SERVER_DOMAIN_NAME
echo "}">>/etc/nginx/sites-enabled/$SERVER_DOMAIN_NAME
service nginx restart


################################################################################
# Step 5 (manual): build a pelias service vagrant box
################################################################################

# You can build a fresh pelias service box with the following commands:
# $ su pelias
# $ cd ~/pelias_vm_builder
# $ sh build_pelias_box.sh my_pelias_vm_box_file.box
# Note: Run the last command in a screen, since it might take several days


################################################################################
# Step 6 (manual): start the pelias service from the vagrant box
################################################################################

# Once you have successfully generated a vagrant box file, you can start the
# pelias service from the box file with the following commands:
# $ su pelias
# $ cd ~/pelias_vm_builder
# $ sh start_pelias_box.sh my_pelias_vm_box_file.box
