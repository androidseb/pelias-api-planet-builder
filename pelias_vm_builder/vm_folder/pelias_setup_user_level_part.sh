#!/bin/bash

# Exit on any error encountered
set -e

MAIN_LOG_FILE_PATH=~/logs_pelias_setup.txt


################################################################################
# Step 1: Download and configure base files
################################################################################

echo "$(date) - Step 1: Download and configure base files">>$MAIN_LOG_FILE_PATH

cd $USERHOME

# create directories
mkdir -p code data bin

# download Valhalla polyline extract to the data dir
mkdir data/polylines
cd data/polylines
# getting the latest download link from https://geocode.earth/data and downloading it with wget
wget $(curl https://geocode.earth/data|grep https://s3.amazonaws.com/geocodeearth-public-data/osm|cut -d \" -f2)
gunzip planet-latest-valhalla.polylines.0sv.gz
mv planet*.0sv extract.0sv
cd ../..

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


# Keep running the script even when facing errors, leaving traces of
# the return codes in the logs with the $? variable
set +e


################################################################################
# Step 2: pelias compose pull
################################################################################

# update all docker images
echo "$(date) - Step 2: pelias compose pull">>$MAIN_LOG_FILE_PATH
pelias compose pull 2>&1 | tee ~/logs_pelias_setup_setup_details_for_pull.txt
echo "$(date) - Step 2: pelias compose pull => $?">>$MAIN_LOG_FILE_PATH


################################################################################
# Step 3: elastic search init
################################################################################

# start elasticsearch server
echo "$(date) - Step 3: elastic search init - start">>$MAIN_LOG_FILE_PATH
pelias elastic start 2>&1 | tee ~/logs_pelias_setup_setup_details_for_es_start.txt
echo "$(date) - Step 3: elastic search init - start => $?">>$MAIN_LOG_FILE_PATH

# wait for elasticsearch to start up
echo "$(date) - Step 3: elastic search init - wait">>$MAIN_LOG_FILE_PATH
pelias elastic wait 2>&1 | tee ~/logs_pelias_setup_setup_details_for_es_wait.txt
echo "$(date) - Step 3: elastic search init - wait => $?">>$MAIN_LOG_FILE_PATH

# create elasticsearch index with pelias mapping
echo "$(date) - Step 3: elastic search init - create">>$MAIN_LOG_FILE_PATH
pelias elastic create 2>&1 | tee ~/logs_pelias_setup_setup_details_for_es_create.txt
echo "$(date) - Step 3: elastic search init - create => $?">>$MAIN_LOG_FILE_PATH


################################################################################
# Step 4: pelias download
################################################################################

#(re)download whosonfirst data
echo "$(date) - Step 4: pelias download - wof">>$MAIN_LOG_FILE_PATH
pelias download wof 2>&1 | tee ~/logs_pelias_setup_setup_details_for_download_wof.txt
echo "$(date) - Step 4: pelias download - wof => $?">>$MAIN_LOG_FILE_PATH

#(re)download openaddresses data
echo "$(date) - Step 4: pelias download - oa">>$MAIN_LOG_FILE_PATH
pelias download oa 2>&1 | tee ~/logs_pelias_setup_setup_details_for_download_oa.txt
echo "$(date) - Step 4: pelias download - oa => $?">>$MAIN_LOG_FILE_PATH

#(re)download openstreetmap data
echo "$(date) - Step 4: pelias download - osm">>$MAIN_LOG_FILE_PATH
pelias download osm 2>&1 | tee ~/logs_pelias_setup_setup_details_for_download_osm.txt
echo "$(date) - Step 4: pelias download - osm => $?">>$MAIN_LOG_FILE_PATH

#(re)download TIGER data
echo "$(date) - Step 4: pelias download - tiger">>$MAIN_LOG_FILE_PATH
pelias download tiger 2>&1 | tee ~/logs_pelias_setup_setup_details_for_download_tiger.txt
echo "$(date) - Step 4: pelias download - tiger => $?">>$MAIN_LOG_FILE_PATH

#(re)download transit data
echo "$(date) - Step 4: pelias download - transit">>$MAIN_LOG_FILE_PATH
pelias download transit 2>&1 | tee ~/logs_pelias_setup_setup_details_for_download_transit.txt
echo "$(date) - Step 4: pelias download - transit => $?">>$MAIN_LOG_FILE_PATH

#(re)download csv data
echo "$(date) - Step 4: pelias download - csv">>$MAIN_LOG_FILE_PATH
pelias download csv 2>&1 | tee ~/logs_pelias_setup_setup_details_for_download_csv.txt
echo "$(date) - Step 4: pelias download - csv => $?">>$MAIN_LOG_FILE_PATH


################################################################################
# Step 5: pelias prepare
################################################################################

# build all services which have a prepare step

# Note: "pelias prepare polylines" is skipped because too heavy on memory for
# a planet build and we downloaded the result as extract.0sv in step 1

echo "$(date) - Step 5: pelias prepare interpolation">>$MAIN_LOG_FILE_PATH
pelias prepare interpolation 2>&1 | tee ~/logs_pelias_setup_setup_details_for_prepare_interpolation.txt
echo "$(date) - Step 5: pelias prepare interpolation => $?">>$MAIN_LOG_FILE_PATH

echo "$(date) - Step 5: pelias prepare placeholder">>$MAIN_LOG_FILE_PATH
pelias prepare placeholder 2>&1 | tee ~/logs_pelias_setup_setup_details_for_prepare_placeholder.txt
echo "$(date) - Step 5: pelias prepare placeholder => $?">>$MAIN_LOG_FILE_PATH


################################################################################
# Step 6: pelias import
################################################################################

# (re)import polylines data
echo "$(date) - Step 6: pelias import polylines">>$MAIN_LOG_FILE_PATH
pelias import polylines 2>&1 | tee ~/logs_pelias_setup_setup_details_for_import_polylines.txt
echo "$(date) - Step 6: pelias import polylines => $?">>$MAIN_LOG_FILE_PATH

# (re)import whosonfirst data
echo "$(date) - Step 6: pelias import wof">>$MAIN_LOG_FILE_PATH
pelias import wof 2>&1 | tee ~/logs_pelias_setup_setup_details_for_import_wof.txt
echo "$(date) - Step 6: pelias import wof => $?">>$MAIN_LOG_FILE_PATH

# (re)import openaddresses data
echo "$(date) - Step 6: pelias import oa">>$MAIN_LOG_FILE_PATH
pelias import oa 2>&1 | tee ~/logs_pelias_setup_setup_details_for_import_oa.txt
echo "$(date) - Step 6: pelias import oa => $?">>$MAIN_LOG_FILE_PATH

# (re)import openstreetmap data
echo "$(date) - Step 6: pelias import osm">>$MAIN_LOG_FILE_PATH
pelias import osm 2>&1 | tee ~/logs_pelias_setup_setup_details_for_import_osm.txt
echo "$(date) - Step 6: pelias import osm => $?">>$MAIN_LOG_FILE_PATH

# (re)import geonames data
echo "$(date) - Step 6: pelias import geonames">>$MAIN_LOG_FILE_PATH
pelias import geonames 2>&1 | tee ~/logs_pelias_setup_setup_details_for_import_geonames.txt
echo "$(date) - Step 6: pelias import geonames => $?">>$MAIN_LOG_FILE_PATH

# (re)import transit data
echo "$(date) - Step 6: pelias import transit">>$MAIN_LOG_FILE_PATH
pelias import transit 2>&1 | tee ~/logs_pelias_setup_setup_details_for_import_transit.txt
echo "$(date) - Step 6: pelias import transit => $?">>$MAIN_LOG_FILE_PATH

# (re)import csv data
echo "$(date) - Step 6: pelias import csv">>$MAIN_LOG_FILE_PATH
pelias import csv 2>&1 | tee ~/logs_pelias_setup_setup_details_for_import_csv.txt
echo "$(date) - Step 6: pelias import csv => $?">>$MAIN_LOG_FILE_PATH


################################################################################
# Step 7: pelias compose up
################################################################################

# start one or more docker-compose service(s)
echo "$(date) - Step 7: compose up">>$MAIN_LOG_FILE_PATH
pelias compose up 2>&1 | tee ~/logs_pelias_setup_setup_details_for_compose_up.txt
echo "$(date) - Step 7: compose up => $?">>$MAIN_LOG_FILE_PATH


################################################################################
# Step 8: cleanup temporary files
################################################################################

cd $USERHOME/data
rm -rf openaddresses #(~43GB)
rm -rf tiger #(~13GB)
rm -rf openstreetmap #(~46GB)
rm -rf polylines #(~2.7GB)

# Within the content of the "interpolation" folder (~176GB) we must
# preserve "street.db" (~7GB) and "address.db" (~25GB), the rest can be deleted
cd interpolation
rm -rf -- !("street.db"|"address.db")
cd ..

# Within the content of the "placeholder" folder (~1.4GB), we must
# preserve the "store.sqlite3" (~0.9GB) file, the rest can be deleted
cd placeholder
rm -rf -- !("store.sqlite3")
cd ..


echo "$(date) - User level setup - Setup completed with success!!!">>~/logs_pelias_setup.txt
