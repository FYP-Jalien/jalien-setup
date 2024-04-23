# Clone the test suite.
clone_if_not_exists() {
    local dir_name="$1"
    local git_repo="$2"
    if [ ! -d "$dir_name" ]; then
        git clone "$git_repo" "$dir_name"
        echo "$git_repo cloned to $dir_name."
    else
        echo "Directory $dir_name already exists, skipping cloning."
        pull_new_changes "$dir_name"
    fi

}

clone_if_not_exists "$TEST_SUITE" "$TEST_SUITE_SOURCE"
