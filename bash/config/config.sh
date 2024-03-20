#!/bin/bash

# Path to the directory where the jalien-setup repository will be cloned
export BASE_DIR=/home/runner/work/jalien-setup/jalien-setup

# Path to directory where which stores all bash files
export SCRIPT_DIR=/home/runner/work/jalien-setup/jalien-setup/bash

# Path to the directory where the shared volume will be created
export SHARED_VOLUME=/home/runner/work/jalien-setup/jalien-setup/SHARED_VOLUME

# Path to the directory where the jalien repository will be cloned
export JALIEN=/home/runner/work/jalien-setup/jalien-setup
# Path to the directory where the jalien-setup repository will be cloned
export JALIEN_SETUP=/home/runner/work/jalien-setup/jalien-setup

export JALIEN_SOURCE="https://github.com/FYP-Jalien/jalien.git"
export JALIEN_SETUP_SOURCE="https://github.com/FYP-Jalien/jalien-setup.git"

# Name of the docker containers
# Might have to change these names
export CE_NAME=shared_volume_JCentral-dev-CE_1
export JCENTRAL_NAME=shared_volume_JCentral-dev_1
export SCHEDD_NAME=shared_volume_schedd_1
export SE_NAME=shared_volume_JCentral-dev-SE_1
export WORKER_NAME=shared_volume_worker1_1
