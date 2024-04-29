#!/bin/bash

set -e

ui_mode=false
if [ "$1" = "ui" ]; then
    ui_mode=true
fi

show_logs=false
if [ "$1" = "logs" ]; then
    show_logs=true
fi

start() {
    if [ $ui_mode = true ] || [ $show_logs = true ]; then
        if sudo docker compose "$SHARED_VOLUME/docker-compose.yml" up; then
            success=true
            echo "All containers are up with Docker logs!!"
        else
            echo "Starting the docker containers with Docker logs failed."
            sleep 5
        fi
    else
        if sudo docker compose "$SHARED_VOLUME/docker-compose.yml" up -d; then
            success=true
            echo "All containers are up!!"
        else
            sleep 5
        fi
    fi
}

max_iterations=5
cur_iteration=0
success=false
while [ "$success" = false ] && [ $cur_iteration -lt $max_iterations ]; do
    cur_iteration=$((cur_iteration + 1))
    echo "Trying to start containers for the $cur_iteration time"
    start
done

if ! $success; then
    echo "Failed to start all containers. Retrying after removing health checks"
    cp "$SHARED_VOLUME/docker-compose.yml" "$SHARED_VOLUME/docker-compose-original.yml"
    sed -i '/depends_on:/,/condition: service_healthy/d' "$SHARED_VOLUME/docker-compose.yml"
    start
fi

echo $success >"$SHARED_VOLUME/success.txt"
