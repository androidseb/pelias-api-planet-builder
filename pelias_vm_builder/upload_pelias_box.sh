#!/bin/bash

# Unless you own a Vagrant box, you don't need this script
# I use this script to update the public Vagrant box for everyone to use

# Exit on any error encountered
set -e

# Run this command manually the first time to sign the machine in
# vagrant cloud auth login

# Checking that we have exactly one argument
if [ $# -ne 2 ]
  then
    echo "Usage: sh upload_pelias_box.sh <box_file_name.box> <version>"
    exit
fi

# Checking that our pwd is the same as this file
if [ $0 != "start_pelias_box.sh" ]
  then
    echo "You must cd to this file's directory before executing it"
    exit
fi

vagrant cloud publish theandroidseb/pelias_planet_api $2 vitualbox $1 --version-description "Version $2" --release
