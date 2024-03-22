#!/bin/bash

set -e

source "$1"

success=false
while [ "$success" = false ]; do
    if sudo docker-compose -f "$SHARED_VOLUME/docker-compose.yml" up -d ; then
        success=true
        echo "All containers are up!!"
    else
        echo "Starting the docker containers failed. Retrying after 15s..."
        sleep 15
    fi
done

