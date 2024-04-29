#!/bin/bash

set -e

source config/config.sh

# Array to collect the pid of the processes that are started in the script.
pids=()

execute() {
    local file="$1"
    chmod +x "$file"
    local is_terminal=0
    for arg in "${@:2}"; do
        if [ "$arg" = "terminal" ]; then
            is_terminal=1
            break
        fi
    done
    if [ $is_terminal -eq 1 ]; then
        if [ "$ui_mode" = true ]; then
            gnome-terminal --tab --title "$3" -- bash -c "$file; ${*:2}" &
            pid=$!
            pids+=($pid)
        else
            "$file" "${@:2}" &
        fi
    else
        "$file" "${@:2}"
    fi
}

kill_pids() {
    for pid in "${pids[@]}"; do
        kill $pid
    done
}

args=("$@")

executePre=false
executeShared=false
executeSync=true
executeJalien=true
executeOpt=true
executeMake=false
remove=false
ui_mode=false
use_local_image=false
run_test_suite=false
show_logs=false

for arg in "${args[@]}"; do
    case $arg in
    --pre)
        executePre=true
        executeShared=true
        executeSync=false
        remove=true
        ;;
    --shared)
        executeShared=true
        executeSync=false
        ;;
    --remove)
        remove=true
        ;;
    --local-images)
        use_local_image=true
        ;;
    --ui)
        ui_mode=true
        ;;
    --no-sync)
        executeSync=false
        ;;
    --no-jalien)
        executeJalien=false
        executeOpt=false
        ;;
    --no-opt)
        executeOpt=false
        ;;
    --make)
        executeMake=true
        ;;
    --test-suite)
        run_test_suite=true
        ;;
    --logs)
        show_logs=true
        ;;
    esac
done

if [ "$executePre" = true ]; then
    execute "$SCRIPT_DIR/tasks/pre_jalien.sh" "$executeMake"
fi

if [ "$executeShared" = true ]; then
    execute "$SCRIPT_DIR/tasks/create_shared.sh" "$use_local_image"
fi

if [ "$executeSync" = true ]; then
    execute "$SCRIPT_DIR/tasks/create_jar.sh"
    execute "$SCRIPT_DIR/tasks/sync_jar.sh"
fi

if [ "$executeJalien" = true ]; then
    if [ "$ui_mode" = true ]; then
        if [ "$executeShared" = true ]; then
            execute "$SCRIPT_DIR/tasks/jalien.sh" "down" "ui"
        elif [ "$remove" = true ]; then
            execute "$SCRIPT_DIR/tasks/jalien.sh" "remove" "ui"
        else
            execute "$SCRIPT_DIR/tasks/jalien.sh" "ui"
        fi
    elif [ $show_logs = true ]; then
        if [ "$executeShared" = true ]; then
            execute "$SCRIPT_DIR/tasks/jalien.sh" "down" "logs"
        elif [ "$remove" = true ]; then
            execute "$SCRIPT_DIR/tasks/jalien.sh" "remove" "logs"
        else
            execute "$SCRIPT_DIR/tasks/jalien.sh" "logs"
        fi
    else
        if [ "$executeShared" = true ]; then
            execute "$SCRIPT_DIR/tasks/jalien.sh" "down"
        elif [ "$remove" = true ]; then
            execute "$SCRIPT_DIR/tasks/jalien.sh" "remove"
        else
            execute "$SCRIPT_DIR/tasks/jalien.sh"
        fi
    fi
fi

if [ "$executeOpt" = true ]; then
    execute "$SCRIPT_DIR/tasks/start_opt.sh" "terminal" "Optimiser"
fi

if [ "$run_test_suite" = true ]; then
    execute "$SCRIPT_DIR/tasks/test_suite.sh" "Test Suite"
    kill_pids                                    # Killing all the processes that were started in the script.
    execute "$SCRIPT_DIR/tasks/jalien.sh" "stop" # Stop the jalien containers.

fi
