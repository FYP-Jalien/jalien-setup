#!/bin/bash

source "$1"

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


