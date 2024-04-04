#!/bin/bash

set -e

source ../config/config.sh


cp "$JALIEN/alien-cs.jar" "$SHARED_VOLUME/"
echo "alien-cs.jar copied to $SHARED_VOLUME/"
