#!/bin/bash

set -e

source "$1"

execute() {
    local file="$1"
    chmod +x "$file"
    if [ "$2" = "terminal" ]; then
        "$file" "$SCRIPT_DIR/config/config.sh" &
    else
        "$file" "$SCRIPT_DIR/config/config.sh"
    fi
}

if [ "$2" = "down" ]; then
    execute "$SCRIPT_DIR/containers/down.sh"
elif [ "$2" = "remove" ]; then
    execute "$SCRIPT_DIR/containers/remove.sh"
else
    execute "$SCRIPT_DIR/containers/stop.sh"
fi

execute "$SCRIPT_DIR/containers/up.sh" "terminal" "ContainerLogs"

containers=(
    "$CE_NAME"
    "$JCENTRAL_NAME"
    "$SCHEDD_NAME"
    "$SE_NAME"
    "$WORKER_NAME"
)

is_container_running() {
    local container_name="$1"
    if sudo docker ps -q --filter "name=$container_name" | grep -q .; then
        return 0
    else
        return 1
    fi
}

max_iterations=100
cur_iteration=0
while [ $cur_iteration -lt $max_iterations ]; do
    all_containers_running=true
    cur_iteration=$((cur_iteration + 1))

    for container_name in "${containers[@]}"; do
        if ! is_container_running "$container_name"; then
            all_containers_running=false
            break
        fi
    done

    if $all_containers_running; then
        echo "All containers are up and running."
        echo "Waiting 200 seconds until containers are finished setting up."
        sleep 200
        echo "All containers are setup"
        break
    else
        echo "Not all containers are up and running. Retrying..."
        sleep 15
    fi
done

if [ $cur_iteration -eq $max_iterations ]; then
    echo "Failed to start all containers."
    sudo docker ps
    exit 1
fi