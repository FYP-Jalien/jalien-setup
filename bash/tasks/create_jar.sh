#!/bin/bash

set -e

source "$1"

pull_new_changes() {
    local dir_name="$1"
    cd "$dir_name" || return

    # Fetch changes from all remote branches
    git fetch --all

    # Check if there are any changes to be pulled
    if [ $(git rev-list HEAD...@{u} --count) -gt 0 ]; then
    
        # Pull changes from all remote branches.
        git pull --all
      
    else
        echo "No new changes to pull."
    fi
}

pull_new_changes $JALIEN

chmod +x "$JALIEN/compile.sh"
"$JALIEN/compile.sh" cs
echo "alien-cs.jar created"
