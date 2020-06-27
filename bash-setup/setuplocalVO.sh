#!/bin/bash
. /testVOEnv.sh

timeout=40

function die() { 
	if [[ $? -ne 0 ]]; then {
		echo "$1"
		exit 1
	}
	fi
}

function run_testj_setup(){
	cd $JALIEN_HOME
	echo "Setting up Environment"
	bash testj test &
	PID=$!
	sleep 5
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

[[ -d $JALIEN_HOME ]] || die "JAliEn path not found!"
run_testj_setup
make_keystore
timeout $timeout tail --pid=$PID -f /dev/null
exit 0