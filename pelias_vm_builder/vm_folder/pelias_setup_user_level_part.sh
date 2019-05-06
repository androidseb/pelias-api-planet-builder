#!/bin/bash

# Exit on any error encountered
set -e

echo "$(date) - User level setup - start">>~/logs_pelias_setup.txt
cd $USERHOME

# create directories
mkdir code data bin

# TODO: try un-commenting this section and replacing
# pelias prepare all
# WITH
# pelias prepare interpolation
# pelias prepare placeholder
#
# download Valhalla polyline extract to the data dir
#mkdir data/polylines
#cd data/polylines
## getting the latest download link from https://geocode.earth/data and downloading it with wget
#wget $(curl https://geocode.earth/data|grep https://s3.amazonaws.com/geocodeearth-public-data/osm|cut -d \" -f2)
##gunzip planet-latest-valhalla.polylines.0sv.gz
#gunzip planet*.gz
#cd ../..

# clone repo
cd code
git clone https://github.com/pelias/docker.git
cd docker

# install pelias command and add it to the user's PATH
ln -s "$(pwd)/pelias" $USERHOME/bin/pelias
echo "export PATH=\$PATH:$USERHOME/bin">>$USERHOME/.bashrc
export PATH=$PATH:$USERHOME/bin

# cwd to the pelias project dir
cd $USERHOME/code/docker/projects/$PELIAS_PROJECT

# create the start_pelias.sh file to be run by root on boot
echo "cd $(pwd)">~/start_pelias.sh
echo "$USERHOME/bin/pelias compose up">>~/start_pelias.sh

# create the env file as we want it
echo "$(date) - User level setup - compose file configuration">>~/logs_pelias_setup.txt
echo "COMPOSE_PROJECT_NAME=$USERNAME" > .env
echo "DOCKER_USER=$(id -u $USERNAME)" >> .env
echo "DATA_DIR=$USERHOME/data" >> .env

# Keep running the script even when facing errors, some of the following
# commands can, return non 0 exit status even though they are fine
# For example
# "pelias prepare all"
# can error out with
# "tiger download dir does not exist"
# even the overall setup is fine
set +e

# update all docker images
echo "$(date) - User level setup - compose pull">>~/logs_pelias_setup.txt
pelias compose pull 2>&1 | tee ~/logs_pelias_setup_setup_details_for_pull.txt

# start elasticsearch server
echo "$(date) - User level setup - elastic start">>~/logs_pelias_setup.txt
pelias elastic start 2>&1 | tee ~/logs_pelias_setup_setup_details_for_es_start.txt

# wait for elasticsearch to start up
echo "$(date) - User level setup - elastic wait">>~/logs_pelias_setup.txt
pelias elastic wait 2>&1 | tee ~/logs_pelias_setup_setup_details_for_es_wait.txt

# create elasticsearch index with pelias mapping
echo "$(date) - User level setup - elastic create">>~/logs_pelias_setup.txt
pelias elastic create 2>&1 | tee ~/logs_pelias_setup_setup_details_for_es_create.txt

# (re)download all data
echo "$(date) - User level setup - download all">>~/logs_pelias_setup.txt
pelias download all 2>&1 | tee ~/logs_pelias_setup_setup_details_for_download.txt

# build all services which have a prepare step
echo "$(date) - User level setup - prepare all">>~/logs_pelias_setup.txt
pelias prepare all 2>&1 | tee ~/logs_pelias_setup_setup_details_for_prepare.txt

# (re)import all data
echo "$(date) - User level setup - import all">>~/logs_pelias_setup.txt
pelias import all 2>&1 | tee ~/logs_pelias_setup_setup_details_for_import.txt

# start one or more docker-compose service(s)
echo "$(date) - User level setup - compose up">>~/logs_pelias_setup.txt
pelias compose up 2>&1 | tee ~/logs_pelias_setup_setup_details_for_compose_up.txt

echo "$(date) - User level setup - Setup completed with success!!!">>~/logs_pelias_setup.txt
