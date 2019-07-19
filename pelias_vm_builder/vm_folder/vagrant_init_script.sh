#!/bin/bash

# Create the data directory in the VM shared folder.
# Since a lot of data is created and deleted during the pelias setup process,
# the resulting VM once compressed will include a lot of these useless changes.
# To avoid that, we make all the changes in the parent machine file system
# directly, and copy the result only at the end, when all files are cleaned up.
mkdir /vagrant_data/pelias_data

# Link the data directory to the pelias user's data folder
ln -s /vagrant_data/pelias_data /home/pelias/data

# Start the full setup
cd /vagrant_data
sh ./pelias_setup_main_as_root.sh

# Remove the link from the pelias user's home folder
rm /home/pelias/data

# Move the data folder from the VM shared folder to the pelias user's home
mv /vagrant_data/pelias_data /home/pelias/data

# Shutdown the VM
shutdown now
