#!/bin/bash

# Exit on any error encountered
set -e

################################################################################
# This script is meant to be run as root from a debian fresh install into
# a screen (see 'screen' command).
# It should allow you to setup your machine from a fresh install to a
# production-ready pelias API.
################################################################################

echo "$(date) - Step 1: install base dependencies">>~/logs_pelias_setup.txt
################################################################################
# Step 1: install base dependencies
################################################################################
apt-get update -qq
apt-get install -y docker docker-compose nginx

echo "$(date) - Step 2: dedicated user creation">>~/logs_pelias_setup.txt
################################################################################
# Step 2: dedicated user creation
################################################################################
export USERNAME=pelias
export USERHOME=/home/$USERNAME
export PELIAS_PROJECT="planet"
# Use this value instead if you want to test with a small dataset first
#export PELIAS_PROJECT="portland-metro"
export USER_SCRIPT_FILE_NAME="pelias_setup_user_level_part.sh"

useradd -d $USERHOME -s /bin/bash -m $USERNAME
usermod -G docker pelias
chmod a+x $USERHOME

echo "export USERNAME=$USERNAME">>$USERHOME/.bashrc
echo "export USERHOME=$USERHOME">>$USERHOME/.bashrc
echo "export PELIAS_PROJECT=$PELIAS_PROJECT">>$USERHOME/.bashrc

cp ./$USER_SCRIPT_FILE_NAME $USERHOME/$USER_SCRIPT_FILE_NAME
chown $USERNAME $USERHOME/$USER_SCRIPT_FILE_NAME
chmod +x $USERHOME/$USER_SCRIPT_FILE_NAME

echo "$(date) - Step 3: pelias full setup as the user">>~/logs_pelias_setup.txt
################################################################################
# Step 3: pelias full setup as the user
################################################################################
cd $USERHOME
su $USERNAME -c "sh $USERHOME/$USER_SCRIPT_FILE_NAME"

echo "$(date) - Setup completed with success!!!">>~/logs_pelias_setup.txt
