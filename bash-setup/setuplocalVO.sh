#!/bin/bash

function die() {
  if [[ $? -ne 0 ]]; then {
    echo "$1"
    exit 1
  }
  fi
}

function make_keystore(){
  (
    set -e
    echo "Setting up certificates"
    openssl pkcs12 -password pass: -export -in "${TVO_CERTS}/cacert.pem" -name alien -inkey "${TVO_CERTS}/cakey.pem" -out "${TVO_CERTS}/alien.p12"
    ln -nfs $TVO_CERTS "${HOME}/.globus"
  )
  die "Certificates could not be generated"
}

target="/root/.j/testVO"
mkdir -p $target

[[ -d $JALIEN_HOME ]] || die "JAliEn path not found!"
pushd $JALIEN_SETUP/bash-setup
    ./CreateConfig.sh $target
    ./CreateCertificates.sh $target
    ./CreateLDAP.sh $target
    ./CreateDB.sh $target
popd

make_keystore
exit 0
