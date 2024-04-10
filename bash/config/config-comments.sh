#!/bin/bash

# Path to the directory where the jalien and jalien-setup repository will be stored
export BASE_DIR=/home/kalana/work/fyp/jalien-setup/bash

# Path to the directory where the shared volume will be created
export SHARED_VOLUME=/home/kalana/work/fyp/SHARED_VOLUME

# Path to the directory where the jalien repository will be cloned
export JALIEN=/home/kalana/work/fyp/jalien
# Path to the directory where the jalien-setup repository will be cloned
export JALIEN_SETUP=/home/kalana/work/fyp/jalien-setup #since this refers to itself, I think we should not need this in the config file(or here we can define it to be obtained using pwd - same regarding SCRIPT_DIR variable in test config file)
export SCRIPT_DIR=$JALIEN_SETUP/bash

export JALIEN_SOURCE="https://gitlab.cern.ch/jalien/jalien"
export JALIEN_SETUP_SOURCE="https://github.com/FYP-Jalien/jalien-setup"

# Name of the docker containers
# Might have to change these names
export CE_NAME=shared_volume_JCentral-dev-CE_1
export JCENTRAL_NAME=shared_volume_JCentral-dev_1
export SCHEDD_NAME=shared_volume_schedd_1
export SE_NAME=shared_volume_JCentral-dev-SE_1
export WORKER_NAME=shared_volume_worker1_1 #container names here are different from container names in test setup which causes test to fail

## For test setup, I would suggest 
## - Showing Warning and Minor tests in different colors
## Fix colors in test summary - If all 35 critical tests get passed we show it as 35 in red which is confusing. red or orange should only highlight a problem
## Add the conclusion to say if we are good to go or not
## Add screenshorts of test summary and the UI mode