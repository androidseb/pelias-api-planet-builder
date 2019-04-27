# Pelias API planet builder

Utility scripts to build and deploy a full planet Pelias API in just a few commands.

Ideal for small apps needing a places search API with a few thousands daily active users.


## Disclaimer

I designed these scripts for my own usage: a small app with less than 10K daily active users. This setup is not scalable and it might not match your use case, but I decided to share it publicly so that other people in my situation can benefit from it.

I hope this work will be helpful to people and that people experimenting and building improvements can contribute back to this project.

I am not willing to invest time to take feature requests at the moment since this project addresses my needs as is. If you find a way to improve the project and want to build it and then submit it as a pull request, I'm willing to work with you to merge your work into the current code though.


## Usage overview

There are 3 phases to using this script:
1. Initial configuration and setup
2. Building a Pelias planet API Vagrant box
3. Running a Pelias planet API Vagrant box

I will refer to the maching building the box as the `builder machine` and I will refer to the machine running the box as the `runner machine`.

The `builder machine` and the `runner machine` can be the same machine.


## Minimum hardware requirements
You will need a machine with at minimum 16GB of RAM and 500GB of disk space. For CPU, the more cores and the faster, the better, since it will speed up your build process. What you pick depends on your patience. If you want to run steps 2 and 3 concurrently, you'll need either 2 machines or a machine with double those capacities.


## Initial configuration and setup


### Initial configuration and setup for a builder machine

If you're building and running with only one machine, you can skip this step.

The builder machine only needs vagrant installed:
* Login as root
* Retrieve this git repo: `git clone https://github.com/androidseb/pelias-api-planet-builder.git`
* CD to the downloaded git repo `cd pelias-api-planet-builder`
* Run the Vagrant install file: `sh install_vagrant.sh`


### Initial configuration and setup for a runner machine

The runner machine will host the API and do some redirection with nginx, so it will require the full install:
* Login as root
* Retrieve this git repo: `git clone https://github.com/androidseb/pelias-api-planet-builder.git`
* CD to the downloaded git repo `cd pelias-api-planet-builder`
* Edit the `config.sh` file to your liking
* Run the install file: `sh install_all.sh`


## Building a Pelias planet API Vagrant box

* Login to your `builder machine`
* CD to the project folder: `cd pelias-api-planet-builder`
* Open a screen session: `screen`
* Run the build command: `sh build_pelias_box.sh my_pelias_vm_box_file.box`
* Detach the screen by pressing Ctrl+a, and then `"`, and then `d`
* Come back from a few days later to check progress: `screen -r`

To give you an idea of how long this can take, it takes about 14 days on a machine with 8 cores CPU: Intel(R) Xeon(R) CPU W3520 @ 2.67GHz, 32GB of RAM and 2TB of regular HDD (not SSD)


## Running a Pelias planet API Vagrant box
* Login to your `runner machine`
* CD to the project folder: `cd pelias-api-planet-builder`
* Copy the file generated from the builder machine if applicable `scp builder_machine:/home/pelias/pelias-api-planet-builder/my_pelias_vm_box_file.box ./`
* Run the start command: `sh start_pelias_box.sh my_pelias_vm_box_file.box`
