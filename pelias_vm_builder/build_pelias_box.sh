#!/bin/bash

# Exit on any error encountered
set -e

# Checking that we have exactly one argument
if [ $# -ne 1 ]
  then
    echo "Usage: sh build_pelias_box.sh <box_file_name.box>"
    exit
fi

# Checking that our pwd is the same as this file
if [ $0 != "build_pelias_box.sh" ]
  then
    echo "You must cd to this file's directory before executing it"
    exit
fi

# Install vagrant plugin "disksize" to allow us to specify the VM disk size
vagrant plugin install vagrant-disksize

# Copying the vagrant file into the working dir
cp -f ./vagrant_files/Vagrantfile_builder ./Vagrantfile

# Starting the vagrant VM + run all the build scripts inside (will take days)
vagrant up

# Wait for the VM to shut down (then end of the setup script will shut down the VM)
echo "Scanning running VMs and waiting for 0 VMs to be running"
running_vms_count=$(vboxmanage list runningvms|wc -l)
while [ $running_vms_count -ne 0 ]
do
  sleep 15
  running_vms_count=$(vboxmanage list runningvms|wc -l)
done
echo "No more VMs are running. Waiting 60 seconds just to be safe..."
sleep 60

# Halting the vagrant machine
vagrant halt

# Packaging the built vm into a vagrant box
vagrant package --output $1

echo "Pelias box successfully built: $1"
