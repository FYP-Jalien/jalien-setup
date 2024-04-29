#!/bin/bash

set -e

pull_new_changes() {
    local dir_name=$JALIEN
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

clone_if_not_exists() {
    local dir_name=$JALIEN
    local git_repo=$JALIEN_SOURCE
    if [ ! -d "$dir_name" ]; then
        git clone "$git_repo" "$dir_name"
        echo "$git_repo cloned to $dir_name."
    else
        pull_new_changes
    fi
}

clone_if_not_exists

chmod +x "$JALIEN/compile.sh"
"$JALIEN/compile.sh" cs
echo "alien-cs.jar created"
