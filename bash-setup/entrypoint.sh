#!/bin/bash

function main() {
    (
        set -e
        cd $JALIEN_HOME
        cp "${JALIEN_DEV}"/*.jar "$JALIEN_HOME"
        bash /setuplocalVO.sh
        bash /verifylocalVO.sh
        cp -r $TVO_CERTS $CERTS
        chown $USER_ID $CERTS && chown $USER_ID "${CERTS}"/*
        bash testj central
    )
exit_on_err 
}

function exit_on_err() {
    exit_code=$?
    if [ $exit_code -ne 0 ]; then
        printf '\n JCENTRAL FAILED TO START \n'
        exit $exit_code
    fi
}

main