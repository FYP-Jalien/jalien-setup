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

TEST_SUITE="/home/malith/Documents/FYP/test-suite"

# Writing the env values for the test suite.
echo "
    export SHARED_VOLUME_PATH=$SHARED_VOLUME
    export JALIEN_SETUP_PATH=$JALIEN_SETUP
    export CONTAINER_NAME_CE=shared_volume_JCentral-dev-CE_1
    export CONTAINER_NAME_CENTRAL=shared_volume_JCentral-dev_1
    export CONTAINER_NAME_SCHEDD=shared_volume_schedd_1
    export CONTAINER_NAME_SE=shared_volume_JCentral-dev-SE_1
    export CONTAINER_NAME_WORKER=shared_volume_worker1_1
    export SCRIPT_DIR=$TEST_SUITE
    export ALIENV_PATH=$TEST_SUITE/files/alma-alienv
    export SAMPLE_JDL_PATH=$TEST_SUITE/files/sample_test.jdl
    export TESTSCRIPT_PATH=$TEST_SUITE/files/testscript_test.sh
" > "$TEST_SUITE/.env"

echo "Test suite env values written to $TEST_SUITE/.env"

# Running the test suite.
cd "$TEST_SUITE"
./index.sh --containers-only
