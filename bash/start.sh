#!/bin/bash

set -e

source config/config.sh

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
            gnome-terminal --tab --title "$3" -- bash -c "$file; ${*:2}"
        else
            "$file" "${@:2}" &
        fi
    else
        "$file" "${@:2}"
    fi
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
