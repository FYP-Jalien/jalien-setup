#!/bin/bash

target="/root/.j/testVO"
mkdir -p $target

pushd $JALIEN_SETUP/bash-setup
    ./CreateLDAP.sh $target
    ./CreateDB.sh $target
popd
