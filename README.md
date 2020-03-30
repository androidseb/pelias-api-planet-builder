# Pelias API planet builder (WORK IN PROGRESS, NOT PRODUCTION-READY YET)

Utility scripts to build and deploy a full planet Pelias API in just a few commands.

Ideal for small apps needing a places search API with a few thousands daily active users.


## Disclaimer

I designed these scripts for my own usage: a small app with less than 10K daily active users. This setup is not scalable and it might not match your use case, but I decided to share it publicly so that other people in my situation can benefit from it.

I hope this work will be helpful to people and that people experimenting and building improvements can contribute back to this project.

I am not willing to invest time to take feature requests at the moment since this project addresses my needs as is. If you find a way to improve the project and want to build it and then submit it as a pull request, I'm willing to work with you to merge your work into the current code though.


## Simple usage overview

I have created a Vagrant box Vagrant cloud, and I have a dedicated machine to building new versions continuously.

However, due to the large size of the Vagrant box file (about 300GB) combined with a bug in Vagrant cloud (can't handle box files of >60GB it seems), I haven't been able to complete this step.

These would be the steps once I'm able to upload my box, if Vagrant fixes that backend bug (I try uploading from time to time):

* install [Vagrant](https://www.vagrantup.com/downloads.html)
* copy the [Vagrant public box file](./pelias_vm_builder/vagrant_files/Vagrantfile_publicbox) to your machine and name it "Vagrantfile"
* from the same directory as the Vagrant file, start Vagrant: `vagrant up`
* wait a few hours
* (optional) verify that the API is up: `curl http://localhost:4000/v1/search?text=portland`
* et voilà !


## Advanced Usage overview

If you don't want to use the pre-made Vagrant images and want to build and import them yourself, you can use the scripts of this project.
There are 3 phases to using this script:
1. Initial configuration and setup
2. Building a Pelias planet API Vagrant box
3. Running a Pelias planet API Vagrant box

I will refer to the maching building the box as the `builder machine` and I will refer to the machine running the box as the `runner machine`.

The `builder machine` and the `runner machine` can be the same machine.


## Minimum hardware requirements
You will need a machine with at minimum 16GB of RAM and 1TB of disk space. For CPU, the more cores and the faster, the better, since it will speed up your build process. What you pick depends on your patience. If you want to run steps 2 and 3 concurrently, you'll need either 2 machines or a machine with double those capacities.


## Initial configuration and setup


### Initial configuration and setup for a builder machine

If you're building and running with only one machine, you can skip this step.

The builder machine only needs vagrant installed:
* Login as root
* Retrieve this git repo: `git clone https://github.com/androidseb/pelias-api-planet-builder.git`
* CD to the downloaded git repo `cd pelias-api-planet-builder`
* Run the Vagrant install file: `./install_vagrant.sh`


### Initial configuration and setup for a runner machine

The runner machine will host the API and do some redirection with nginx, so it will require the full install:
* Login as root
* Retrieve this git repo: `git clone https://github.com/androidseb/pelias-api-planet-builder.git`
* CD to the downloaded git repo `cd pelias-api-planet-builder`
* Edit the `config.sh` file to your liking
* Run the install file (this will create a dedicated pelias user): `./install_all.sh`


## Building a Pelias planet API Vagrant box

* Login to your `builder machine` as the dedicated pelias user
* Go to the vm builder folder in your home: `cd ~/pelias_vm_builder`
* Open a screen session: `screen`
* Run the build command: `sh build_pelias_box.sh my_pelias_vm_box_file.box`
* Detach the screen by pressing Ctrl+a, and then `"`, and then `d`
* Come back from a few days later to check progress: `screen -r`

To give you an idea of how long this can take, it takes about 23 days on a machine with 8 cores CPU: Intel(R) Xeon(R) CPU W3520 @ 2.67GHz, 32GB of RAM and 2TB of regular HDD (not SSD).

Here is the log dump of my last build process:
```
Sun Mar  1 17:05:09 UTC 2020 - Step 1: Download and configure base files
Sun Mar  1 17:09:16 UTC 2020 - User level setup - compose file configuration
Sun Mar  1 17:09:16 UTC 2020 - Step 2: pelias compose pull
Sun Mar  1 17:20:47 UTC 2020 - Step 2: pelias compose pull => 0
Sun Mar  1 17:20:47 UTC 2020 - Step 3: elastic search init - start
Sun Mar  1 17:20:54 UTC 2020 - Step 3: elastic search init - start => 0
Sun Mar  1 17:20:54 UTC 2020 - Step 3: elastic search init - wait
Sun Mar  1 17:21:12 UTC 2020 - Step 3: elastic search init - wait => 0
Sun Mar  1 17:21:12 UTC 2020 - Step 3: elastic search init - create
Sun Mar  1 17:21:17 UTC 2020 - Step 3: elastic search init - create => 0
Sun Mar  1 17:21:17 UTC 2020 - Step 4: pelias download - wof
Sun Mar  1 18:08:25 UTC 2020 - Step 4: pelias download - wof => 0
Sun Mar  1 18:08:25 UTC 2020 - Step 4: pelias download - oa
Mon Mar  2 00:24:03 UTC 2020 - Step 4: pelias download - oa => 0
Mon Mar  2 00:24:03 UTC 2020 - Step 4: pelias download - osm
Mon Mar  2 01:41:18 UTC 2020 - Step 4: pelias download - osm => 0
Mon Mar  2 01:41:18 UTC 2020 - Step 4: pelias download - tiger
Mon Mar  2 02:34:52 UTC 2020 - Step 4: pelias download - tiger => 0
Mon Mar  2 02:34:52 UTC 2020 - Step 4: pelias download - transit
Mon Mar  2 02:34:59 UTC 2020 - Step 4: pelias download - transit => 0
Mon Mar  2 02:34:59 UTC 2020 - Step 4: pelias download - csv
Mon Mar  2 02:35:02 UTC 2020 - Step 4: pelias download - csv => 0
Mon Mar  2 02:35:02 UTC 2020 - Step 5: pelias prepare interpolation
Wed Mar 18 08:40:53 UTC 2020 - Step 5: pelias prepare interpolation => 0
Wed Mar 18 08:40:53 UTC 2020 - Step 5: pelias prepare placeholder
Wed Mar 18 16:30:13 UTC 2020 - Step 5: pelias prepare placeholder => 0
Wed Mar 18 16:30:13 UTC 2020 - Step 6: pelias import polylines
Wed Mar 18 21:46:00 UTC 2020 - Step 6: pelias import polylines => 0
Wed Mar 18 21:46:00 UTC 2020 - Step 6: pelias import wof
Wed Mar 18 22:49:34 UTC 2020 - Step 6: pelias import wof => 0
Wed Mar 18 22:49:34 UTC 2020 - Step 6: pelias import oa
Sat Mar 21 12:30:00 UTC 2020 - Step 6: pelias import oa => 0
Sat Mar 21 12:30:00 UTC 2020 - Step 6: pelias import osm
Sun Mar 22 23:15:25 UTC 2020 - Step 6: pelias import osm => 0
Sun Mar 22 23:15:25 UTC 2020 - Step 6: pelias import geonames
Mon Mar 23 01:31:37 UTC 2020 - Step 6: pelias import geonames => 0
Mon Mar 23 01:31:37 UTC 2020 - Step 6: pelias import transit
Mon Mar 23 01:31:45 UTC 2020 - Step 6: pelias import transit => 0
Mon Mar 23 01:31:45 UTC 2020 - Step 6: pelias import csv
Mon Mar 23 01:31:50 UTC 2020 - Step 6: pelias import csv => 0
Mon Mar 23 01:31:50 UTC 2020 - Step 7: compose up
Mon Mar 23 01:32:05 UTC 2020 - Step 7: compose up => 0
```


## Running a Pelias planet API Vagrant box
* Login to your `runner machine`
* CD to the project folder: `cd pelias-api-planet-builder`
* Copy the file generated from the builder machine if applicable `scp builder_machine:/home/pelias/pelias-api-planet-builder/my_pelias_vm_box_file.box ./`
* Run the start command: `sh start_pelias_box.sh my_pelias_vm_box_file.box`
