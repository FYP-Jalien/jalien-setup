#!/bin/bash

# Path to the directory where the jalien-setup repository will be cloned
export BASE_DIR=/home/malith/Documents/FYP

# Path to directory where which stores all bash files
export SCRIPT_DIR=/home/malith/Documents/FYP/bash

# Path to the directory where the shared volume will be created
export SHARED_VOLUME=/home/malith/Documents/FYP/SHARED_VOLUME

# Path to the directory where the jalien repository will be cloned
export JALIEN=/home/malith/Documents/FYP/notes
# Path to the directory where the jalien-setup repository will be cloned
export JALIEN_SETUP=/home/malith/Documents/FYP/jalien-setup

export JALIEN_SOURCE="https://github.com/Malith-19/Sem-7-Notes.git"
export JALIEN_SETUP_SOURCE="https://github.com/FYP-Jalien/jalien-setup"

# Name of the docker containers
# Might have to change these names
export CE_NAME=shared_volume_JCentral-dev-CE_1
export JCENTRAL_NAME=shared_volume_JCentral-dev_1
export SCHEDD_NAME=shared_volume_schedd_1
export SE_NAME=shared_volume_JCentral-dev-SE_1
export WORKER_NAME=shared_volume_worker1_1
