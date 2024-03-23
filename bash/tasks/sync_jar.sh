#!/bin/bash

set -e

source "$1"


cp "$JALIEN/alien-cs.jar" "$SHARED_VOLUME/"
echo "alien-cs.jar copied to $SHARED_VOLUME/"
