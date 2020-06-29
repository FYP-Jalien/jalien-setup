#!/bin/bash
#can have a testconfig.sh, for all commands and source it within script
#set -e
. /testVOEnv.sh

mkdir -p $TVO_CERTS $TVO_TRUSTS 
#CA cert/key
openssl genrsa -out "${TVO_CERTS}/cakey.pem" 1024
chmod 400 "${TVO_CERTS}/cakey.pem"
openssl req -new -batch -key "${TVO_CERTS}/cakey.pem" -x509 -days 365 -out "${TVO_CERTS}/cacert.pem" -subj $CERTSUBJECT_CA
chmod 440 "${TVO_CERTS}/cacert.pem"
openssl rehash $TVO_CERTS
CA_hash=`openssl x509 -hash -noout -in "${TVO_CERTS}/cacert.pem"`
#USER cert/key
openssl req -nodes -newkey rsa:1024 -out "${TVO_CERTS}/userreq.pem" -keyout "${TVO_CERTS}/userkey.pem" -subj $CERTSUBJECT_USER
chmod 440 "${TVO_CERTS}/usercert.pem"
chmod 400 "${TVO_CERTS}/userkey.pem"
USER_hash=`openssl x509 -hash -noout -in "${TVO_CERTS}/usercert.pem"`
#HOST cert/key
openssl req -nodes -newkey rsa:1024 -out "${TVO_CERTS}/hostreq.pem" -keyout "${TVO_CERTS}/hostkey.pem" -subj $CERTSUBJECT_HOST
chmod 440 "${TVO_CERTS}/hostcert.pem"
chmod 400 "${TVO_CERTS}/hostkey.pem"
HOST_hash=`openssl x509 -hash -noout -in "${TVO_CERTS}/hostcert.pem"`
openssl pkcs12 -password pass: -export -in "${TVO_CERTS}/cacert.pem" -name alien -inkey "${TVO_CERTS}/cakey.pem" -out "${TVO_TRUSTS}/alien.p12"
#AUTH
openssl req -x509 -nodes -days 365 -newkey rsa:1024 -keyout "${TVO_CERTS}/AuthZ_priv.pem" -out "${TVO_CERTS}/AuthZ_pub.pem" -subj $CERTSUBJECT_JAUTH
#SE
openssl req -x509 -nodes -days 365 -newkey rsa:1024 -keyout "${TVO_CERTS}/SE_priv.pem" -out "${TVO_CERTS}/SE_pub.pem" -subj $CERTSUBJECT_SE