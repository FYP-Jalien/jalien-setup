#!/bin/bash

set -e

pull_new_changes() {
    local dir_name="$1"
    cd "$dir_name" || return

    # Fetch changes from all remote branches
    git fetch --all

    # Check if there are any changes to be pulled
    if [ $(git rev-list HEAD...@{u} --count) -gt 0 ]; then
    
        # Attempt to pull changes from all remote branches
        if git pull --all; then
            echo "Changes pulled successfully."
        else
            echo "Failed to pull changes. Resolving conflicts..."
        fi
      
    else
        echo "No new changes to pull."
    fi
}

pull_new_changes $JALIEN

chmod +x "$JALIEN/compile.sh"
"$JALIEN/compile.sh" cs
echo "alien-cs.jar created"
