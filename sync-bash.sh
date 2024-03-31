#!/bin/bash

BASH_REPOSITORY=https://github.com/FYP-Jalien/bash/

if [ -d "./bash" ]; then
    echo "Updating existing 'bash' repository..."
    cd ./bash || {
        echo "Error: Unable to change directory to './bash'"
        exit 1
    }
    git pull || {
        echo "Error: Unable to pull changes from the repository"
        exit 1
    }
else
    echo "Cloning 'bash' repository from $BASH_REPOSITORY..."
    git clone "$BASH_REPOSITORY" || {
        echo "Error: Unable to clone repository"
        exit 1
    }
fi
