#!/bin/bash

# Exit on any error encountered
set -e

# Checking that we have exactly one argument
if [ $# -ne 1 ]
  then
    echo "Usage: sh start_pelias_box.sh <box_file_name.box>"
    exit
fi

# Checking that our pwd is the same as this file
if [ $0 != "start_pelias_box.sh" ]
  then
    echo "You must cd to this file's directory before executing it"
    exit
fi

# Copying the vagrant file into the working dir
cp -f ./vagrant_files/Vagrantfile_runner ./Vagrantfile

# Importing the vagrant box
vagrant box add --force --name pelias_api $1

# Destroying any existing vagrant machines
vagrant destroy

# Starting the vagrant VM + run all the build scripts inside (will take days)
vagrant up

echo "Pelias box successfully started: $1"
