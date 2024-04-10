#!/bin/bash

set -e


ui_mode=false
if [ "$2" = "ui" ]; then
    ui_mode=true
fi

success=false
while [ "$success" = false ]; do
    if [ $ui_mode = true ]; then
        if sudo docker-compose -f "$SHARED_VOLUME/docker-compose.yml" up; then
            success=true
            echo "All containers are up!!"
        else
            echo "Starting the docker containers failed. Retrying after 15s..."
            sleep 15
        fi
    else
        if sudo docker-compose -f "$SHARED_VOLUME/docker-compose.yml" up -d; then
            success=true
            echo "All containers are up!!"
        else
            echo "Starting the docker containers failed. Retrying after 15s..."
            sleep 15
        fi
    fi
done
