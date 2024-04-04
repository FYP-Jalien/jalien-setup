#!/bin/bash

source ../config/config.sh

use_local_image=$2

# Function to set chmod to +x and execute the input
execute() {
    local file="$1"
    chmod +x "$file"
    "$file" "$SCRIPT_DIR/config/config.sh"
}

# Remove the shared volume if it exists
if [ -d "$SHARED_VOLUME" ]; then
    rm -rf "$SHARED_VOLUME"
    echo "Directory $SHARED_VOLUME has been removed."
fi

# Create the alien-cs.jar
execute "$SCRIPT_DIR/tasks/create_jar.sh"

# Set the shared volume path
export SHARED_VOLUME=$SHARED_VOLUME

# Create SHARED_VOLUME
echo "$SHARED_VOLUME is creating...."
"$JALIEN_SETUP/bin/jared" --jar "$JALIEN/alien-cs.jar" --volume "$SHARED_VOLUME"
echo "$SHARED_VOLUME created"

if [ "$use_local_image" = true ]; then
    central_image="jalien-base"
    se_image="xrootd-se"
    worker_image="worker-base"
    ce_image="jalien-ce"
    sed -i "s/image: kaveeshadinamidu\/$central_image:latest/image: $central_image/g" "$SHARED_VOLUME/docker-compose.yml"
    sed -i "s/image: kaveeshadinamidu\/$se_image:latest/image: $se_image/g" "$SHARED_VOLUME/docker-compose.yml"
    sed -i "s/image: kaveeshadinamidu\/$worker_image:latest/image: $worker_image/g" "$SHARED_VOLUME/docker-compose.yml"
    sed -i "s/image: kaveeshadinamidu\/$ce_image:latest/image: $ce_image/g" "$SHARED_VOLUME/docker-compose.yml"
fi
