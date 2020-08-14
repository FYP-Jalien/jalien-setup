#!/bin/bash

function die() {
  if [[ $? -ne 0 ]]; then {
    echo "$1"
    exit 1
  }
  fi
}

target="/root/.j/testVO"
mkdir -p $target

[[ -d $JALIEN_HOME ]] || die "JAliEn path not found!"
pushd $JALIEN_SETUP/bash-setup
    ./CreateLDAP.sh $target
    ./CreateDB.sh $target
popd

exit 0
