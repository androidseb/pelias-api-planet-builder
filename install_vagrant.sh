#!/bin/bash

# Exit on any error encountered
set -e

# Install virtualbox
apt-get install -y virtualbox

# Install vagrant
wget https://releases.hashicorp.com/vagrant/2.2.4/vagrant_2.2.4_x86_64.deb
dpkg -i vagrant_2.2.4_x86_64.deb
